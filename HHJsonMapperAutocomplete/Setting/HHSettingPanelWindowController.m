//
//  HHSettingPanelWindowController.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/5/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHSettingPanelWindowController.h"
#import "HHJsonMapperAutocompleteSetting.h"

@interface HHSettingPanelWindowController ()

@property (weak) IBOutlet NSTextField *tfTrigger;
@property (weak) IBOutlet NSPopUpButton *popUpButton;
@property (weak) IBOutlet NSTextField *tfMapperMethod;
@property (weak) IBOutlet NSButton *resetButton;

@end

@implementation HHSettingPanelWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    HHJsonMapperAutocompleteSetting *defaultSetting = [HHJsonMapperAutocompleteSetting defaultSetting];
    [self.tfTrigger setStringValue:[defaultSetting triggerString]];
    [self.tfMapperMethod setStringValue:[defaultSetting mapperMethodString]];
    [self.popUpButton selectItemAtIndex:1];
    
}

#pragma mark - Delegate

- (void)controlTextDidChange:(NSNotification *)notification
{
    if([notification object] == self.tfTrigger) {
        [[HHJsonMapperAutocompleteSetting defaultSetting] setTriggerString:self.tfTrigger.stringValue];
    }
    if([notification object] == self.tfMapperMethod) {
        [[HHJsonMapperAutocompleteSetting defaultSetting] setMapperMethodString:self.tfMapperMethod.stringValue];
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    if (control == self.tfTrigger) {
        if (self.tfTrigger.stringValue.length == 0) {
            [self.tfTrigger setStringValue:HHJDefaultTriggerString];
        }
    }
    return YES;
}

#pragma mark - Event
- (IBAction)pupUpButtonUpdate:(NSPopUpButton *)sender {
    NSUInteger selectedIndex = sender.indexOfSelectedItem;
    NSLog(@"index : %@", @(selectedIndex));
    
}
- (IBAction)resetButtonClicked:(NSButton *)button {
}

@end
