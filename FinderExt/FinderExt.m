//
//  FinderInj.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "FinderExt.h"

#import <objc/runtime.h>

/**
 * Renames the selector for a given method.
 * Searches for a method with origSEL and reassigned overrideSEL to that
 * implementation.
 * http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
 */
void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
{
    Method origMethod = class_getInstanceMethod(c, origSEL);
    Method overrideMethod = class_getInstanceMethod(c, overrideSEL);
    
    NSLog(@"orig=%p, override=%p", origMethod, overrideMethod);
    
    if(class_addMethod(c, origSEL, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(c, overrideSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

void OverrideClass(const char *name, Method overrideMethod) {
    Class c = objc_getClass(name);
    if (c != nil) {
        // add override method to target class
        class_addMethod(c,
                        method_getName(overrideMethod),
                        method_getImplementation(overrideMethod),
                        method_getTypeEncoding(overrideMethod));
        // swizzle methods
        MethodSwizzle(c, @selector(menuForEvent:), method_getName(overrideMethod));
        NSLog(@"Method 'menuForEvent:' overriden in class %s", name);
    } else {
        NSLog(@"Class %s not found to override", name);
    }
}

@implementation FinderExt

+ (void)load {
    // Setup logging
    // Write log file to ~/FinderExt.log
    const char* logFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"FinderExt.log"] UTF8String];
    freopen(logFilePath, "a", stdout);
    freopen(logFilePath, "a", stderr);
    
    NSLog(@"Main bundle: %@", [[NSBundle mainBundle] bundleIdentifier]);
    
    Method method = class_getInstanceMethod(self, @selector(override_menuForEvent:));
    
    OverrideClass("TListView", method);
    OverrideClass("TBrowserTableView", method);
    
    NSLog(@"FinderExt load is complete");
}

- (NSMenu *)override_menuForEvent:(NSEvent *)event {
    NSLog(@"In overriden method");
    
    NSMenu *menu = [self override_menuForEvent:event];
    
    NSLog(@"%ld items in menu", [menu numberOfItems]);
    
    if ([event type] == NSRightMouseDown) {
        NSLog(@"RightMouseDown handle");
        for (NSMenuItem *item in [menu itemArray]) {
            NSLog(@"Item '%@'", [item title]);
        }
        
        // Add item
        //[menu addItem:[[NSMenuItem alloc] initWithTitle:@"My menu"
        //                                               action:nil
        //                                        keyEquivalent:@""]];
    }
    
    return menu;
}

@end
