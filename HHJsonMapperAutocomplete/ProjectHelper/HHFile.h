//
//  HHFile.h
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/29/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCodePrivate.h"

@interface HHFile : NSObject

- (instancetype)initWithPBXReference:(PBXReference *)pbxReference;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *absolutePath;
@property (nonatomic, readonly) PBXContainer *container;

@property (nonatomic, readonly) BOOL isTestFile;
@property (nonatomic, readonly) BOOL isSourceFile;
@property (nonatomic, readonly) BOOL isHeaderFile;

@end
