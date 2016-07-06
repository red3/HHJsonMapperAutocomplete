//
//  HHJsonMapperAutocomplete.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/26/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHJsonMapperAutocomplete.h"
#import "HHSettingPanelWindowController.h"
#import "NSTextView+VVTextGetter.h"
#import "NSTextView+HHTextGetter.h"
#import "NSString+VVSyntax.h"
#import "VVKeyboardEventSender.h"
#import "VVTextResult.h"
#import "HHJsonMapperAutocompleteSetting.h"
#import "HHWorkspaceManager.h"
#import "HHProject.h"
#import "HHDocumenter.h"



static HHJsonMapperAutocomplete *sharedPlugin;

@interface HHJsonMapperAutocomplete ()

@property (nonatomic, strong) id eventMonitor;
@property (nonatomic, assign) BOOL prefixTyped;
@property (nonatomic, strong) HHSettingPanelWindowController *settingPanel;

@end

@implementation HHJsonMapperAutocomplete

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textStorageDidChange:)
                                                         name:NSTextDidChangeNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    // Create menu items, initialize UI, etc.
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Window"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *newMenuItem = [[NSMenuItem alloc] initWithTitle:@"HHJsonMapperAutocomplete" action:@selector(showSettingPanel:) keyEquivalent:@""];
        
        [newMenuItem setTarget:self];
        [[editMenuItem submenu] addItem:newMenuItem];
        return YES;
    } else {
        return NO;
    }
}

- (void)showSettingPanel:(NSNotification *)noti {
    self.settingPanel = [[HHSettingPanelWindowController alloc] initWithWindowNibName:@"HHSettingPanelWindowController"];
    [self.settingPanel showWindow:self.settingPanel];
}

- (void)textStorageDidChange:(NSNotification *)noti {
    
    if (![[noti object] isKindOfClass:[NSTextView class]]) {
        return;
    }
    
    NSTextView *textView = (NSTextView *)[noti object];
    VVTextResult *currentLineResult = [textView vv_textResultOfCurrentLine];
    if (!currentLineResult) {
        return;
    }
    
    //Check if there is a "??" already typed in. We do this to solve the undo issue
    //Otherwise when you press Cmd+Z, "???" will be recognized and trigger the doc inserting, so you can not perform an undo.
    NSString *triggerString = [[HHJsonMapperAutocompleteSetting defaultSetting] triggerString];
    
    if (triggerString.length > 1) {
        NSString *preTypeString = [triggerString substringToIndex:triggerString.length - 2];
        self.prefixTyped = [currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:preTypeString]]] | self.prefixTyped;
    } else {
        self.prefixTyped = YES;
    }
    
    if ([currentLineResult.string vv_matchesPatternRegexPattern:[NSString stringWithFormat:@"^\\s*%@$",[NSRegularExpression escapedPatternForString:triggerString]]] && self.prefixTyped) {
        
        
        //Get a @"///" (triggerString) typed in by user. Do work!
        self.prefixTyped = NO;
        
        // __block BOOL shouldReplace = NO;
        
        NSString *filePath = [HHWorkspaceManager currentEditingFilePath];
        NSLog(@"file path : %@", filePath);
        
        NSDictionary *properties = [HHProject propertyListWithPath:filePath];
        NSLog(@"array : %@", properties);
        NSArray *implementations = [textView hh_implementationsOfPreviousLines];
        NSLog(@"imp : %@", implementations);
        
        NSString *implementation = [implementations lastObject];
        NSArray *propertiesArray = [properties objectForKey:implementation];
        if (!propertiesArray) {
            return;
        }
        
        HHDocumenter *documenter = [[HHDocumenter alloc] initWithProperties:propertiesArray];
        
        
        NSString *documentationString = documenter.jsonKeyPaths;
        
        if (!documentationString) {
            //Leave the user's input there.
            //It might be no need to parse doc or something wrong.
            return;
        }
        
        //Now we are using a simulation of keyboard event to insert the docs, instead of using the IDE's private method.
        //See more at https://github.com/onevcat/VVDocumenter-Xcode/issues/3
        
        //Save current content in paste board
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        NSString *originPBString = [pasteBoard stringForType:NSPasteboardTypeString];
        
        //Set the doc comments in it
        [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [pasteBoard setString:documentationString forType:NSStringPboardType];
        
        //Begin to simulate keyborad pressing
        VVKeyboardEventSender *kes = [[VVKeyboardEventSender alloc] init];
        [kes beginKeyBoradEvents];
        //Cmd+delete Delete current line
        [kes sendKeyCode:kVK_Delete withModifierCommand:YES alt:NO shift:NO control:NO];
        //if (shouldReplace) [textView setSelectedRange:resultToDocument.range];
        //Cmd+V, paste (which key to actually use is based on the current keyboard layout)
        NSInteger kKeyVCode = [[HHJsonMapperAutocompleteSetting defaultSetting] keyVCode];
        [kes sendKeyCode:kKeyVCode withModifierCommand:YES alt:NO shift:NO control:NO];
        
        //The key down is just a defined finish signal by me. When we receive this key, we know operation above is finished.
        [kes sendKeyCode:kVK_F20];
        self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent *incomingEvent) {
            if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F20) {
                //Finish signal arrived, no need to observe the event
                [NSEvent removeMonitor:self.eventMonitor];
                self.eventMonitor = nil;
                
                //Restore previois patse board content
                [pasteBoard setString:originPBString forType:NSStringPboardType];
                
                //Set cursor before the inserted documentation. So we can use tab to begin edit.
                int baseIndentationLength = 0;
                [textView setSelectedRange:NSMakeRange(currentLineResult.range.location + baseIndentationLength, 0)];
                
                //Send a 'tab' after insert the doc. For our lazy programmers. :)
                // [kes sendKeyCode:kVK_Tab];
                [kes endKeyBoradEvents];
                
               
                
                //Invalidate the finish signal, in case you set it to do some other thing.
                return nil;
            } else if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kKeyVCode) {
                //Select input line and the define code block.
                
                //NSRange r begins from the starting of enum(struct) line. Select 1 character before to include the trigger input line.
                NSRange r = [[[textView selectedRanges] objectAtIndex:0] rangeValue];
                [textView setSelectedRange:r];
                return incomingEvent;
            } else {
                return incomingEvent;
            }
        }];
        
    }
    
    
    
    
    
}



@end
