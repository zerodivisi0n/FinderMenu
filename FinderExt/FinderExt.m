//
//  FinderInj.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "FinderExt.h"

#import <objc/runtime.h>

#import "Finder.h"
#import "TFENodeHelper.h"

static TFENodeHelper *gNodeHelper;

// Auxiliary class to execute menu actions
@interface MenuItemTarget : NSObject {
    @private
    NSArray *_files;
}
- (id)initWithNodes:(const struct TFENodeVector *)vector;
- (void)sayHello:(id)sender;
- (void)sayGoodbye:(id)sender;
@end

@implementation MenuItemTarget
- (id)initWithNodes:(const struct TFENodeVector *)vector {
    self = [super init];
    if (self) {
        NSInteger capacity = vector->_end - vector->_begin;
        NSMutableArray *files = [[NSMutableArray alloc] initWithCapacity:capacity];
        struct TFENode *node;
        for (node = vector->_begin; node < vector->_end; ++node) {
            [files addObject: [gNodeHelper pathForNode:node]];
        }
        _files = files;
    }
    return self;
}

- (void)sayMessage:(NSString *)title {
    [[NSAlert alertWithMessageText:title
                    defaultButton:nil
                  alternateButton:nil
                      otherButton:nil
        informativeTextWithFormat:@"Files: %@", _files] runModal];
    
    [self release];
}

- (void)sayHello:(id)sender { [self sayMessage:@"Hello"]; }
- (void)sayGoodbye:(id)sender { [self sayMessage:@"Goodbye"]; }
@end

/**
 * Renames the selector for a given method.
 * Searches for a method with origSEL and reassigned overrideSEL to that
 * implementation.
 * http://www.mikeash.com/pyblog/friday-qa-2010-01-29-method-replacement-for-fun-and-profit.html
 */
static void MethodSwizzle(Class c, SEL origSEL, SEL overrideSEL)
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

static void OverrideClass(const char *name, SEL origSEL, Method overrideMethod) {
    Class c = objc_getClass(name);
    if (c != nil) {
        // add override method to target class
        class_addMethod(c,
                        method_getName(overrideMethod),
                        method_getImplementation(overrideMethod),
                        method_getTypeEncoding(overrideMethod));
        // swizzle methods
        MethodSwizzle(c, origSEL, method_getName(overrideMethod));
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
    
    // Create helper object
    gNodeHelper = [[TFENodeHelper alloc] init];
    if (gNodeHelper == nil) {
        NSLog(@"Failed to instantiate 'TFENodeHelper' class");
        return;
    }
    
    Method method = class_getInstanceMethod(self, @selector(override_configureWithNodes:browserController:container:));
    OverrideClass("TContextMenu", @selector(configureWithNodes:browserController:container:), method);
    
    NSLog(@"FinderExt load is complete");
}

- (void)override_configureWithNodes:(const struct TFENodeVector *)vector
                  browserController:(id)browserController
                          container:(BOOL)container {
    [self override_configureWithNodes:vector browserController:browserController container:container];
    
    NSMenu *contextMenu = (NSMenu *)self;
    
    // Find first separator to insert menu after it
    NSInteger index;
    for (index = 1 /* 0 is always separator  */; index < [contextMenu numberOfItems]; ++index) {
        if ([[contextMenu itemAtIndex:index] isSeparatorItem]) {
            // separator found!
            break;
        }
    }
    
    MenuItemTarget *myMenuTarget = [[MenuItemTarget alloc] initWithNodes:vector];
    
    // Build extension menu
    NSMenuItem *myMenuItem = [[NSMenuItem alloc] initWithTitle:@"My Menu" action:nil keyEquivalent:@""];
    NSMenu *mySubmenu = [[NSMenu alloc] initWithTitle:@"My menu"];
    [mySubmenu setAutoenablesItems:NO];
    [[mySubmenu addItemWithTitle:@"Say Hello"
                          action:@selector(sayHello:)
                   keyEquivalent:@""]
     setTarget:myMenuTarget];
    [[mySubmenu addItemWithTitle:@"Say Goodbye"
                          action:@selector(sayGoodbye:)
                   keyEquivalent:@""]
     setTarget:myMenuTarget];
    [myMenuItem setSubmenu:mySubmenu];
    
    // Add menu
    [contextMenu insertItem:myMenuItem atIndex:index + 1];
    [contextMenu insertItem:[NSMenuItem separatorItem] atIndex:index + 2];
}

@end
