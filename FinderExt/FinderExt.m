//
//  FinderInj.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "FinderExt.h"

#import <objc/runtime.h>

#import "mach_override.h"

typedef void (*BuildContextMenuProc)(Class, SEL, NSMenu *, unsigned int, id, unsigned long long, BOOL);

BuildContextMenuProc gOrigContextMenuProc;

void override_buildContextMenu(Class c, SEL s, NSMenu *menu, unsigned int context, id browserController, unsigned long long maxItems, BOOL addServices) {
    NSLog(@"In override method for menu: %@", menu);
    gOrigContextMenuProc(c, s, menu, context, browserController, maxItems, addServices);
}

@implementation FinderExt

+ (void)load {
    // Setup logging
    // Write log file to ~/FinderExt.log
    const char* logFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"FinderExt.log"] UTF8String];
    freopen(logFilePath, "a", stdout);
    freopen(logFilePath, "a", stderr);
    
    NSLog(@"Main bundle: %@", [[NSBundle mainBundle] bundleIdentifier]);
    
    Class class_TContextMenu = objc_getClass("TContextMenu");
    if (class_TContextMenu != nil) {
        Method original_buildContextMenu = class_getClassMethod(class_TContextMenu, @selector(buildContextMenu:forContext:browserController:maxItems:addServices:));
        if (original_buildContextMenu != nil) {
            mach_error_t err;
            err = mach_override_ptr(method_getImplementation(original_buildContextMenu), override_buildContextMenu, (void**)&gOrigContextMenuProc);
            NSLog(@"Override result: %d", err);
        } else {
            NSLog(@"Method 'buildContextMenu:forContext:browserController:maxItems:addServices:' not found in 'TContextMenu' class");
        }
    } else {
        NSLog(@"Class 'TContextMenu' not found in process");
    }
    
    NSLog(@"FinderExt load is complete");
}

@end
