//
//  Finder.h
//  FinderMenu
//
//  Required Finder's interface declarations
//  Obtained using 'class_dump' tool ( http://www.codethecode.com/projects/class-dump/ )
//
//  Created by Alexey Zhuchkov on 11/4/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

struct OpaqueNodeRef;

struct TFENode {
    struct OpaqueNodeRef *fNodeRef;
};

struct TFENodeVector {
    struct TFENode *_begin;
    struct TFENode *_end;
    struct TFENode *_end_cap;
};

@interface FINode
// Old interface:
+ (FINode *)nodeWithFENode:(const struct TFENode *)node;
@property(readonly) NSString *fullPath;

// New interface:
+ (FINode *)nodeFromNodeRef:(struct OpaqueNodeRef *)nodeRef;
@property(readonly) NSURL *previewItemURL;
@end
