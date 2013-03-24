//
//  ILTFENodeUtils.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILTFENodeUtils.h"

#import <objc/runtime.h>

typedef enum {
  PathForNodeImplUndefined = 0,
  PathForNodeImplUnknown = 1,
  PathForNodeImplNodeWithFENode = 2,
  PathForNodeImplNodeFromNodeRef = 3
} PathForNodeImpl;

NSString *pathForNode(const struct TFENode *node)
{
  static Class FINode_class = NSClassFromString(@"FINode");
  static PathForNodeImpl impl = PathForNodeImplUndefined;
  
  if (!FINode_class) {
    // Key class not found
    return nil;
  }
  
  // Select implementation
  if (impl == PathForNodeImplUndefined) {
    if (class_getClassMethod(FINode_class, @selector(nodeWithFENode:))
        && class_getInstanceMethod(FINode_class, @selector(fullPath))) {
      impl = PathForNodeImplNodeWithFENode;
    } else if (class_getClassMethod(FINode_class, @selector(nodeFromNodeRef:))
               && class_getInstanceMethod(FINode_class, @selector(previewItemURL))) {
      impl = PathForNodeImplNodeFromNodeRef;
    } else {
      impl = PathForNodeImplUnknown;
    }
  }
  
  // Get path
  NSString *path = nil;
  FINode *fiNode;
  switch (impl) {
    case PathForNodeImplNodeWithFENode:
      fiNode = [FINode_class nodeWithFENode:node];
      path = [fiNode fullPath];
      break;
    case PathForNodeImplNodeFromNodeRef:
      fiNode = [FINode_class nodeFromNodeRef:node->fNodeRef];
      path = [[fiNode previewItemURL] path];
      break;
    default:
      break;
  }
  
  return path;
}

NSArray *pathsForNodes(const struct TFENodeVector *nodes)
{
  NSMutableArray *paths = [NSMutableArray arrayWithCapacity:nodes->size()];
  for (TFENodeVector::const_iterator it = nodes->begin(); it != nodes->end(); ++it) {
    NSString *filePath = pathForNode(&*it);
    if (filePath) {
      [paths addObject:filePath];
    }
  }
  return paths;
}