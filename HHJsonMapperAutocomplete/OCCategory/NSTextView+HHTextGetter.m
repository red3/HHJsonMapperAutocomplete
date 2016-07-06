//
//  NSTextView+HHTextGetter.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 7/6/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "NSTextView+HHTextGetter.h"

@implementation NSTextView (HHTextGetter)

- (NSInteger)hh_currentCurseLocation
{
    return [[[self selectedRanges] objectAtIndex:0] rangeValue].location;
}

-(NSArray <NSString *> *)hh_implementationsOfPreviousLines {
    
    NSRange range = [[[self selectedRanges] objectAtIndex:0] rangeValue];
    NSString *text = [self.textStorage.string substringWithRange:NSMakeRange(0, range.location)];
  
    NSArray *array = getImplementationsByContent(text);
    return array;
    
}


NSArray *getImplementationsByContent(NSString *content) {
    
    NSString *regex = @"(@implementation\\s*\\S*)";
    
    NSError *error=nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    
    NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    NSMutableArray *results = @[].mutableCopy;
    for (NSTextCheckingResult *result in res) {
        NSString *test = [content substringWithRange:result.range];
        
        test = [[test componentsSeparatedByString:@" "] lastObject];
        [results addObject:test];
    }
    
    return [results copy];
    
}






@end
