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

static BuildContextMenuProc gOrigContextMenuProc;

void override_buildContextMenu(Class c, SEL s, NSMenu *menu, unsigned int context, id browserController, unsigned long long maxItems, BOOL addServices) {
    NSLog(@"In override method for menu: %@", menu);
    gOrigContextMenuProc(c, s, menu, context, browserController, maxItems, addServices);
    
    // Find first separator to insert menu after it
    NSInteger index;
    for (index = 1 /* 0 is always separator  */; index < [menu numberOfItems]; ++index) {
        if ([[menu itemAtIndex:index] isSeparatorItem]) {
            // separator found!
            break;
        }
    }
    
    NSLog(@"Separator found at index: %ld", index);
    
    // Build extension menu
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@"My Menu" action:nil keyEquivalent:@""];
    NSMenu *mySubmenu = [[NSMenu alloc] initWithTitle:@"My menu"];
    [mySubmenu addItemWithTitle:@"Say Hello" action:nil keyEquivalent:@""];
    [mySubmenu addItemWithTitle:@"Say Goodbye" action:nil keyEquivalent:@""];
    [myMenuItem setSubmenu:mySubmenu];
    
    // Add menu
    [menu insertItem:myMenuItem atIndex:index + 1];
    [menu insertItem:[NSMenuItem separatorItem] atIndex:index + 2];
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
            if (err == err_none) {
                NSLog(@"Override successful!");
            } else {
                NSLog(@"Override error: %d", err);
            }
        } else {
            NSLog(@"Method 'buildContextMenu:forContext:browserController:maxItems:addServices:' not found in 'TContextMenu' class");
        }
    } else {
        NSLog(@"Class 'TContextMenu' not found in process");
    }
    
    NSLog(@"FinderExt load is complete");
}

@end
