//
//  HHDocumenter.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 7/6/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHDocumenter.h"

@interface HHDocumenter ()

@property (nonatomic, copy) NSArray *properties;
@property (nonatomic, copy) NSString *code;


@end

@implementation HHDocumenter

- (instancetype)initWithProperties:(NSArray <NSString *> *)properties code:(NSString *)code {
    self = [super init];
    if (!self) {
        return nil;
    }
    _properties = properties;
    _code = code;
    return self;
}

- (NSString *)jsonKeyPaths {
    
    NSString *code = [NSString stringWithFormat:@"%@ {\n    return @{\n", self.code];
    NSMutableString *str = [code mutableCopy];

    
    NSArray *array = self.properties;
    
    
    NSUInteger maxLen = 0;
    
    for (NSString *propername in array) {
        if (propername.length > maxLen) {
            maxLen = propername.length;
        }
    }
    
    for (int i = 0;i < array.count; i++) {
        
        NSString *propertyName = [array objectAtIndex:i];
        
        //计算空格个数
        NSInteger count = maxLen - propertyName.length;
        NSMutableString *firstPropertyName = [NSMutableString stringWithFormat:@"@\"%@\"",propertyName];
        if (count > 0) {
            
            for (int j = 0; j < count; j++) {
                [firstPropertyName appendString:@" "];
            }
            
        }
        
        [firstPropertyName appendString:@": "];
        
        NSString *comma = i == (array.count - 1) ? @"\n" : @",\n";
        NSString *value = [NSString stringWithFormat:@"         %@@\"%@\"%@",firstPropertyName,propertyName,comma];
        [str appendString:value];
    }
    
    [str appendString:[NSString stringWithFormat:@"    };\n}"]];
    
    return str;
    
}



@end
