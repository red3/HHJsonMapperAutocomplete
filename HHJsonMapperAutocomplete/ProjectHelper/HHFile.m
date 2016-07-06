//
//  HHFile.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/29/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHFile.h"

@interface HHFile ()

@property (nonatomic, readonly) PBXFileReference *pbxFileReference;


@end

@implementation HHFile

- (instancetype)initWithPBXReference:(PBXFileReference *)pbxReference {
    if (self = [super init]) {
        _pbxFileReference = pbxReference;
        
        NSSet *targets = [self.pbxFileReference includingTargets];
        if (targets.count) {
            _isTestFile = YES;
        } else {
            _isHeaderFile = YES;
        }
        
        for (PBXTarget *target in [targets allObjects]) {
            if (![target _looksLikeUnitTestTarget]) {
                _isTestFile = NO;
            }
        }
        
        if (!self.isTestFile) {
            if ([self.pbxFileReference.name.pathExtension isEqualToString:@"m"]) {
                _isSourceFile = YES;
            } else {
                _isHeaderFile = YES;
            }
        }
    }
    return self;
}

- (NSString *)name {
    return self.pbxFileReference.name;
}

- (NSString *)absolutePath {
    return self.pbxFileReference.absolutePath;
}

- (PBXContainer *)container {
    return self.pbxFileReference.container;
}

@end
