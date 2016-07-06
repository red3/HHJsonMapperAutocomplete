//
//  HHWorkspaceManager.h
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/29/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XCodePrivate.h"

@interface HHWorkspaceManager : NSObject

+ (IDEWorkspace *)currentWorkspace;
+ (IDESourceCodeDocument *)currentSourceCodeDocument;

+ (NSString *)currentEditingFilePath;


@end
