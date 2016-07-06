//
//  HHJsonMapperAutocompleteSetting.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/5/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHJsonMapperAutocompleteSetting.h"
#import <Carbon/Carbon.h>

NSString *const HHJDefaultTriggerString = @"???";
NSString *const HHJDefaultAuthorString = @"";
NSString *const HHJDefaultMapperMethodString = @"+ (NSDictionary*)modelCustomPropertyMapper";

NSString *const kHHJTriggerString = @"com.hirain.HHJsonMapperAutocomplete.triggerString";
NSString *const kHHJMapperMethodString = @"com.hirain.HHJsonMapperAutocomplete.mapperMethodString";
NSString *const kHHJJsonModelOption = @"com.hirain.HHJsonMapperAutocomplete.jsonModelOption";


NSString *const kVVDUseSpaces = @"com.onevcat.VVDocumenter.useSpaces";
NSString *const kVVDPrefixWithStar = @"com.onevcat.VVDocumenter.prefixWithStar";

@implementation HHJsonMapperAutocompleteSetting





-(NSInteger) keyVCode
{
    TISInputSourceRef inputSource = TISCopyCurrentKeyboardLayoutInputSource();
    NSString *layoutID = (__bridge NSString *)TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID);
    CFRelease(inputSource);
    
    // Possible dvorak layout SourceIDs:
    //    com.apple.keylayout.Dvorak (System Qwerty)
    // But exclude:
    //    com.apple.keylayout.DVORAK-QWERTYCMD (System Qwerty ⌘)
    //    org.unknown.keylayout.DvorakImproved-Qwerty⌘ (http://www.macupdate.com/app/mac/24137/dvorak-improved-keyboard-layout)
    if ([layoutID localizedCaseInsensitiveContainsString:@"dvorak"] && ![layoutID localizedCaseInsensitiveContainsString: @"qwerty"]) {
        return kVK_ANSI_Period;
    }
    
    // Possible workman layout SourceIDs (https://github.com/ojbucao/Workman):
    //    org.sil.ukelele.keyboardlayout.workman.workman
    //    org.sil.ukelele.keyboardlayout.workman.workmanextended
    //    org.sil.ukelele.keyboardlayout.workman.workman-io
    //    org.sil.ukelele.keyboardlayout.workman.workman-p
    //    org.sil.ukelele.keyboardlayout.workman.workman-pextended
    //    org.sil.ukelele.keyboardlayout.workman.workman-dead
    if ([layoutID localizedCaseInsensitiveContainsString:@"workman"]) {
        return kVK_ANSI_B;
    }
    
    return kVK_ANSI_V;
}



+ (HHJsonMapperAutocompleteSetting *)defaultSetting {
    static dispatch_once_t once;
    static HHJsonMapperAutocompleteSetting *defaultSetting;
    dispatch_once(&once, ^ {
        defaultSetting = [[HHJsonMapperAutocompleteSetting alloc] init];
        
        NSDictionary *defaults = @{kVVDPrefixWithStar: @YES,
                                   kVVDUseSpaces: @YES};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return defaultSetting;
    
}

- (NSString *)triggerString
{
    NSString *s = [[NSUserDefaults standardUserDefaults] stringForKey:kHHJTriggerString];
    if (s.length == 0) {
        s = HHJDefaultTriggerString;
    }
    return s;
}

- (void)setTriggerString:(NSString *)triggerString
{
    if (triggerString.length == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:HHJDefaultTriggerString forKey:kHHJTriggerString];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:triggerString forKey:kHHJTriggerString];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)mapperMethodString {
    NSString *mapperMethodString = [[NSUserDefaults standardUserDefaults] objectForKey:kHHJMapperMethodString];
    if (mapperMethodString == nil || mapperMethodString.length == 0) {
        mapperMethodString = HHJDefaultMapperMethodString;
    }
    return mapperMethodString;
    
}

- (void)setMapperMethodString:(NSString *)mapperMethodString {
    [[NSUserDefaults standardUserDefaults] setObject:mapperMethodString forKey:kHHJMapperMethodString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HHJJsonModelOption)jsonModelOption {
    return (HHJJsonModelOption)[[NSUserDefaults standardUserDefaults] integerForKey:kHHJJsonModelOption];
}

- (void)setJsonModelOption:(HHJJsonModelOption)jsonModelOption {
    [[NSUserDefaults standardUserDefaults] setInteger:jsonModelOption forKey:kHHJJsonModelOption];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
