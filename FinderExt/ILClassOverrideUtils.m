//
//  ILClassOverrideHelper.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/23/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILClassOverrideUtils.h"

#import <objc/runtime.h>

void overrideClassMethod(Class origClass, SEL origSEL, Class overrideClass, SEL overrideSEL)
{
  Method origMethod, overrideMethod;
  
  overrideMethod = class_getClassMethod(overrideClass, overrideSEL);
  Class metaClass = object_getClass(origClass);
  class_addMethod(metaClass,  // add method to meta class
                  overrideSEL,
                  method_getImplementation(overrideMethod),
                  method_getTypeEncoding(overrideMethod));
  
  origMethod = class_getClassMethod(origClass, origSEL);
  overrideMethod = class_getClassMethod(origClass, overrideSEL);
  method_exchangeImplementations(origMethod, overrideMethod);
}

void overrideInstanceMethod(Class origClass, SEL origSEL, Class overrideClass, SEL overrideSEL)
{
  Method origMethod, overrideMethod;
  
  overrideMethod = class_getInstanceMethod(overrideClass, overrideSEL);
  class_addMethod(origClass,
                  overrideSEL,
                  method_getImplementation(overrideMethod),
                  method_getTypeEncoding(overrideMethod));
  
  origMethod = class_getInstanceMethod(origClass, origSEL);
  overrideMethod = class_getInstanceMethod(origClass, overrideSEL);
  method_exchangeImplementations(origMethod, overrideMethod);
}
