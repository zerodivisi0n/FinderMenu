//
//  ILPathMenuDelegate.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/24/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILSimpleMenuDelegate.h"

@interface ILPathMenuDelegate : ILSimpleMenuDelegate {
 @private
  NSString *_path;
}

- (id)initWithPath:(NSString *)path
          menuItem:(NSMenuItem *)menuItem
             index:(NSInteger)index;

@end
