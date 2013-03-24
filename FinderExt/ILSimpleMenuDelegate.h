//
//  ILSimpleMenuDelegate.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILFinderMenu.h"

@interface ILSimpleMenuDelegate : NSObject <ILFinderMenuDelegate> {
 @private
  NSMenuItem *_menuItem;
  NSInteger _index;
}

- (id)initWithMenuItem:(NSMenuItem *)menuItem atIndex:(NSInteger)index;

@end
