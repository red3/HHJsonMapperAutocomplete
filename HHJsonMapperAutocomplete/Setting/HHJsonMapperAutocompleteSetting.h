//
//  HHJsonMapperAutocompleteSetting.h
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/5/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HHJJsonModelOption) {
    HHJJsonModelOptionYYModel,
    HHJJsonModelOptionMantle,
    HHJJsonModelOptionJsonModel,
    HHJSinceOptionCustom,
};

extern NSString *const HHJDefaultTriggerString;
extern NSString *const HHJDefaultMapperMethodString;
extern NSInteger HHJDefaultJsonModelOption;


@interface HHJsonMapperAutocompleteSetting : NSObject

+ (HHJsonMapperAutocompleteSetting *)defaultSetting;

@property (readonly) NSInteger keyVCode;

@property NSString *triggerString;
@property NSString *mapperMethodString;
@property HHJJsonModelOption jsonModelOption;

- (NSString *)recommendableMapperMethodStringWithJsonModelOption:(HHJJsonModelOption)option;




@end
