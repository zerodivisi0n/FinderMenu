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

#ifdef __cplusplus
#include <vector>
class TFENodeVector  : public std::vector<TFENode>  { };
#else  // !__cplusplus
struct TFENodeVector;
#endif
  

@interface FINode : NSObject

// Lion & Mountain Lion
+ (id)nodeFromNodeRef:(struct OpaqueNodeRef *)nodeRef;
@property(readonly) NSURL *previewItemURL;

// Snow Leopard
+ (id)nodeWithFENode:(const struct TFENode *)node;
@property(readonly) NSString *fullPath;

@end
