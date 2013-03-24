//
//  FinderInj.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import "FinderExt.h"

#import "ILFinderMenu.h"
#import "ILPathMenuDelegate.h"

@implementation FinderExt

static FinderExt *_instance = nil;

+ (void)load {
  
  NSLog(@"Main bundle: %@", [[NSBundle mainBundle] bundleIdentifier]);
  if (!_instance) {
    _instance = [[FinderExt alloc] init];
  }
  NSLog(@"FinderExt load is complete");
}

- (id)init
{
  self = [super init];
  if (self) {
    [self setupLogging];
    
    NSMenuItem *menuItem = [self createMenuItem];
    [self injectMenuItem:menuItem];
  }
  return self;
}

- (void)setupLogging
{
  // Write log file to ~/FinderExt.log
  const char* logFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"FinderExt.log"] UTF8String];
  freopen(logFilePath, "a", stdout);
  freopen(logFilePath, "a", stderr);
}

- (NSMenuItem *)createMenuItem
{
  NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:@"Test menu"
                                                    action:nil
                                             keyEquivalent:@""];
  NSMenu *submenu = [[NSMenu alloc] initWithTitle:@"My menu"];
  [submenu setAutoenablesItems:NO];
  [[submenu addItemWithTitle:@"Item 1"
                       action:@selector(itemClicked:)
                keyEquivalent:@""]
   setTarget:self];
  [[submenu addItemWithTitle:@"Item 2"
                       action:@selector(itemClicked:)
                keyEquivalent:@""]
   setTarget:self];
  [menuItem setSubmenu:submenu];
  return menuItem;
}

- (void)injectMenuItem:(NSMenuItem *)menuItem
{
  // Create menu only in User's home directory
  ILSimpleMenuDelegate *simpleDelegate = [[[ILPathMenuDelegate alloc]
                                           initWithPath:NSHomeDirectory()
                                           menuItem:menuItem
                                           index:4]
                                          autorelease];
  [[ILFinderMenu sharedInstance] setDelegate:simpleDelegate];
}

- (void)itemClicked:(id)sender
{
  NSMenuItem *item = (NSMenuItem *)sender;
  [[NSAlert alertWithMessageText:[NSString stringWithFormat:@"%@ clicked", [item title]]
                   defaultButton:nil
                 alternateButton:nil
                     otherButton:nil
       informativeTextWithFormat:@"Selected files: %@", [[ILFinderMenu sharedInstance] selectedItems]]
   runModal];
}

@end
