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


@end

@implementation HHDocumenter

- (instancetype)initWithProperties:(NSArray <NSString *> *)properties {
    self = [super init];
    if (!self) {
        return nil;
    }
    _properties = properties;
    return self;
}

- (NSString *)jsonKeyPaths {
    
    NSMutableString *str = [@"+ (NSDictionary *)JSONKeyPathsByPropertyKey {\n    return @{\n" mutableCopy];
    
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
    
    [str appendString:[NSString stringWithFormat:@"\n    };\n}"]];
    
    return str;
    
}



@end
