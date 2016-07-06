//
//  HHProject.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/29/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHProject.h"
#import "HHWorkspaceManager.h"
#import "HHFile.h"

@implementation HHProject

+ (NSDictionary *)propertyListWithPath:(NSString *)path {
    
    // file content
    NSString *content = [self getFileContent];;
    
    //包含光标的头文件名称
    NSArray *interfaces = getIntefaceNameByContent(content);
    
    //获得所有propertes
    NSDictionary *properties = getPropertiesByInterfaceName(interfaces, content);
    
    return properties;
    
}

+ (NSArray *)fileReferences {
    
    NSArray *projectFiles = [self flattenedProjectContents];
    
    NSMutableArray *references = [NSMutableArray array];
    
    for (PBXReference *pbxReference in projectFiles) {
        
        HHFile *file = [[HHFile alloc] initWithPBXReference:pbxReference];
        if (references) {
            [references addObject:file];
        }
        
    }
    
    return [references copy];
}



+ (NSArray *)flattenedProjectContents {
    NSArray *workspaceReferencedContainers = [[[HHWorkspaceManager currentWorkspace] referencedContainers] allObjects];
    NSArray *contents = [NSArray array];
    
    for (IDEContainer *container in workspaceReferencedContainers) {
        if ([container isKindOfClass:NSClassFromString(@"Xcode3Project")]) {
            Xcode3Project *project = (Xcode3Project *)container;
            Xcode3Group *rootGroup = [project rootGroup];
            PBXGroup *pbxGroup = [rootGroup group];
            
            NSMutableArray *groupContents = [NSMutableArray array];
            [pbxGroup flattenItemsIntoArray:groupContents];
            contents = [contents arrayByAddingObjectsFromArray:groupContents];
        }
    }
    
    return contents;
    
}

//获取文件内容
+ (NSString *)getFileContent {
    
    IDESourceCodeDocument *doc = [HHWorkspaceManager currentSourceCodeDocument];
    if (doc) {
        DVTFilePath *filePath = doc.filePath;
        NSString *fileName = filePath.fileURL.lastPathComponent;
        NSLog(@"filenamemmememe : %@", fileName);
        fileName = [self fileNameByStrippingExtensionAndLastOccuranceOfTest:fileName];
        
        HHFile *headerRef = nil;
        HHFile *sourceRef = nil;
        NSArray *fileReferences = [self fileReferences];
        for (HHFile *reference in fileReferences) {
            if ([reference.name rangeOfString:fileName].location != NSNotFound) {
                if ([reference.name.pathExtension isEqualToString:@"m"]) {
                    sourceRef = reference;
                } else if ([reference.name.pathExtension isEqualToString:@"h"]) {
                    headerRef = reference;
                    
                    NSString *path = reference.absolutePath;
                    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
                    
                    
                    return string;
                }
            }
        }
    }
    
    return nil;
    
}

+ (NSString *)fileNameByStrippingExtensionAndLastOccuranceOfTest:(NSString *)fileName {
    NSString *file = [fileName stringByDeletingPathExtension];
    NSString *strippedFileName = nil;
    
    if (file.length >= 5) {
        NSRange rangeOfOccurrenceOfTest = [file rangeOfString:@"Test" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        
        NSRange rangeOfOccurrenceOfSpec = [file rangeOfString:@"Spec" options:NSCaseInsensitiveSearch range:NSMakeRange(file.length - 5, 5)];
        if (rangeOfOccurrenceOfTest.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfTest.location];
        } else if (rangeOfOccurrenceOfSpec.location != NSNotFound) {
            strippedFileName = [file substringToIndex:rangeOfOccurrenceOfSpec.location];
        } else {
            strippedFileName = file;
        }
    } else {
        strippedFileName = file;
    }
    
    return strippedFileName;
}

NSArray *getIntefaceNameByContent(NSString *content) {
    
    NSString *regex = @"(@interface\\s*\\S*)";
    
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

NSDictionary *getPropertiesByInterfaceName(NSArray *interfaces, NSString *content) {
    
    NSMutableDictionary *propertyDics = @{}.mutableCopy;
    
    for (NSString *interfaceName in interfaces) {
        
        NSString *regex = [NSString stringWithFormat:@"@interface\\s+%@(?s)(.*)@end",interfaceName];
        
        NSError *error = nil;
        NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
        NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
        
        for (NSTextCheckingResult *result in res) {
            NSString *test = [content substringWithRange:result.range];
            
            //匹配property
            NSArray *properties = getRegexResult(@"@property.*?;", test);
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSTextCheckingResult *subResult in properties) {
                
                
                NSString *subString = [test substringWithRange:subResult.range];
                
                NSRange lastStarRange = [subString rangeOfString:@"*" options:NSBackwardsSearch];
                NSRange lastSpaceRange = [subString rangeOfString:@" " options:NSBackwardsSearch];
                
                NSString *str;
                if (lastSpaceRange.location > lastStarRange.location || lastStarRange.length == 0) {
                    str = [subString substringWithRange:NSMakeRange(lastSpaceRange.location, subString.length - lastSpaceRange.location)];
                } else {
                    str = [subString substringWithRange:NSMakeRange(lastStarRange.location, subString.length - lastStarRange.location)];
                }
                NSMutableCharacterSet *set = [[NSMutableCharacterSet alloc] init];
                [set addCharactersInString:@" *;"];
                //去掉空格和逗号
                NSMutableArray *strArr = [[str componentsSeparatedByCharactersInSet:set] mutableCopy];
                [strArr removeObject:@" "];
                str = [strArr componentsJoinedByString:@""];
                
                [array addObject:str];
            }
            [propertyDics setObject:array forKey:interfaceName];
        }


    }
    return [propertyDics copy];

}

NSArray *getRegexResult(NSString *regex,NSString *content) {
    
    NSError *error = nil;
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
    NSArray *res = [pattern matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    
    return res;
}






@end
