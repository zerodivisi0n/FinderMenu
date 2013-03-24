//
//  ILTFENodeUtils.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Finder.h"

#ifdef __cplusplus
extern "C" {
#endif
  
NSString *pathForNode(const struct TFENode *node);
NSArray *pathsForNodes(const struct TFENodeVector *nodes);
  
#ifdef __cplusplus
}
#endif
