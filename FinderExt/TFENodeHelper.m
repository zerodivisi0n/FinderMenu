//
//  TFENodeHelper.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 11/4/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "TFENodeHelper.h"

#import <objc/runtime.h>

#import "Finder.h"

@implementation TFENodeHelper

- (id)init {
    self = [super init];
    if (self) {
        _class = NSClassFromString(@"FINode");
        _ctorType = TFENodeCtorTypeUnknown;
        _pathMethodType = TFENodePathMethodTypeUnknown;
        
        if (_class) {
            if (class_getClassMethod(_class, @selector(nodeWithFENode:))) {
                _ctorType = TFENodeCtorTypeNodeWithFENode;
            } else if (class_getClassMethod(_class, @selector(nodeFromNodeRef:))) {
                _ctorType = TFENodeCtorTypeNodeFromNodeRef;
            }
            
            if (class_getInstanceMethod(_class, @selector(fullPath))) {
                _pathMethodType = TFENodePathMethodTypeFullPath;
            } else if (class_getInstanceMethod(_class, @selector(previewItemURL))) {
                _pathMethodType = TFENodePathMethodTypePreviewItemURL;
            }
        }
        
        if (!_class
            || (_ctorType == TFENodePathMethodTypeUnknown)
            || (_pathMethodType == TFENodePathMethodTypeUnknown)) {
            
            [self release];
            return nil;
        }
    }
    return self;
}

- (NSString *)pathForNode:(const struct TFENode *)node {
    FINode *fiNode = nil;
    NSString *path = nil;
    switch (_ctorType) {
        case TFENodeCtorTypeNodeWithFENode:
            fiNode = [_class nodeWithFENode:node];
            break;
        case TFENodeCtorTypeNodeFromNodeRef:
            fiNode = [_class nodeFromNodeRef:node->fNodeRef];
            break;
        default:
            break;
    }
    
    NSURL *url;
    if (fiNode) {
        switch (_pathMethodType) {
            case TFENodePathMethodTypeFullPath:
                path = [fiNode fullPath];
                break;
            case TFENodePathMethodTypePreviewItemURL:
                url = [fiNode previewItemURL];
                path = [url path];
            default:
                break;
        }
    }
    
    return path;
}

- (NSArray *)arrayForNodeVector:(const struct TFENodeVector *)vector
{
    NSInteger capacity = vector->_end - vector->_begin;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:capacity];
    struct TFENode *node;
    for (node = vector->_begin; node < vector->_end; ++node) {
        [array addObject: [self pathForNode:node]];
    }
    return array;
}

@end
