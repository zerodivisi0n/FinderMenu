//
//  ILClassOverrideHelper.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/23/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

void overrideClassMethod(Class origClass, SEL origSEL, Class overrideClass, SEL overrideSEL);
void overrideInstanceMethod(Class origClass, SEL origSEL, Class overrideClass, SEL overrideSEL);

#ifdef __cplusplus
}
#endif
