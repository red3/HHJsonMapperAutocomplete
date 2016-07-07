//
//  HHDocumenter.h
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 7/6/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHDocumenter : NSObject

- (instancetype)initWithProperties:(NSArray <NSString *> *)properties code:(NSString *)code;

@property (nonatomic, copy) NSString *jsonKeyPaths;

@end
