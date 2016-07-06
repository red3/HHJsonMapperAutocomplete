//
//  HHJsonMapperAutocomplete.h
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/26/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface HHJsonMapperAutocomplete : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end