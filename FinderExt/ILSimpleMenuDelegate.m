//
//  ILSimpleMenuDelegate.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILSimpleMenuDelegate.h"

@implementation ILSimpleMenuDelegate

- (id)initWithMenuItem:(NSMenuItem *)menuItem atIndex:(NSInteger)index
{
  self = [super init];
  if (self) {
    _menuItem = [menuItem retain];
    _index = index;
  }
  return self;
}

- (void)dealloc
{
  [_menuItem release];
  [super dealloc];
}

- (void)finderWillShowContextMenu:(NSMenu *)menu
{
  if ([_menuItem menu]) {
    // Detach from previous menu
    [[_menuItem menu] removeItem:_menuItem];
  }
  [menu insertItem:_menuItem atIndex:_index];
}

@end
