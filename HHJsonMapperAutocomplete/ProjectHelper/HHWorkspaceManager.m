//
//  HHWorkspaceManager.m
//  HHJsonMapperAutocomplete
//
//  Created by Herui on 6/29/16.
//  Copyright © 2016 hirain. All rights reserved.
//

#import "HHWorkspaceManager.h"

@interface HHWorkspaceManager ()

+ (IDEEditorContext *)currentEditorContext;
+ (id)currentEditor;
+ (IDEWorkspaceDocument *)currentWorkspaceDocument;
+ (IDEWorkspace *)currentWorkspace;

@end

@implementation HHWorkspaceManager

+ (IDEEditorContext *)currentEditorContext {
    IDEEditorContext *editorContext = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if ([currentWindowController isKindOfClass:NSClassFromString(@"IDEWorkspaceWindowController")]) {
        IDEEditorArea *editorArea = [(IDEWorkspaceWindowController *)currentWindowController editorArea];
        editorContext = editorArea.lastActiveEditorContext;
    }
    return editorContext;
}

+ (id)currentEditor {
    return self.currentEditorContext.editor;
}

+ (IDEWorkspaceDocument *)currentWorkspaceDocument {
    IDEWorkspaceDocument *workspaceDocument = nil;
    NSWindowController *currentWindowController = [[NSApp keyWindow] windowController];
    if (currentWindowController && [currentWindowController.document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
        workspaceDocument = (IDEWorkspaceDocument *)currentWindowController.document;
    }
    return workspaceDocument;
}

+ (IDEWorkspace *)currentWorkspace {
    return self.currentWorkspaceDocument.workspace;
}

+ (IDESourceCodeDocument *)currentSourceCodeDocument {
    IDESourceCodeDocument *sourceCodeDocument = nil;
    
    if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeEditor")]) {
        sourceCodeDocument = [self.currentEditor sourceCodeDocument];
    } else if ([self.currentEditor isKindOfClass:NSClassFromString(@"IDESourceCodeComparisonEditor")] && [[self.currentEditor primaryDocument] isKindOfClass:NSClassFromString(@"IDESourceCodeDocument")]) {
        sourceCodeDocument = (IDESourceCodeDocument *)[self.currentEditor primaryDocument];
    }
    
    return sourceCodeDocument;
}

+ (NSString *)currentEditingFilePath {
    IDESourceCodeDocument *doc = [HHWorkspaceManager currentSourceCodeDocument];
    if (doc) {
        DVTFilePath *filePath = doc.filePath;
        NSString *fileName = filePath.fileURL.lastPathComponent;
        return fileName;
    }
    return nil;
}


@end
