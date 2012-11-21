//
//  TFENodeHelper.h
//  FinderMenu
//
//  Helper class to get full path from TFENode
//
//  Created by Alexey Zhuchkov on 11/4/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward declarations
struct TFENode;
struct TFENodeVector;

typedef enum {
    TFENodeCtorTypeUnknown,
    TFENodeCtorTypeNodeWithFENode,  // nodeWithFENode
    TFENodeCtorTypeNodeFromNodeRef,  // nodeFromNodeRef
} TFENodeCtorType;

typedef enum {
    TFENodePathMethodTypeUnknown,
    TFENodePathMethodTypeFullPath,  // fullPath
    TFENodePathMethodTypePreviewItemURL,  // previewItemURL
} TFENodePathMethodType;

@interface TFENodeHelper : NSObject {
    @private
    Class _class;
    TFENodeCtorType _ctorType;
    TFENodePathMethodType _pathMethodType;
}

- (NSString *)pathForNode:(const struct TFENode *)node;
- (NSArray *)arrayForNodeVector:(const struct TFENodeVector *)vector;
@end
