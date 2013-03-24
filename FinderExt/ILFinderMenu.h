//
//  ILFinderMenu.h
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/23/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ILFinderMenuDelegate <NSObject>
- (void)finderWillShowContextMenu:(NSMenu *)menu;
@end

@interface ILFinderMenu : NSObject {
 @private
  id<ILFinderMenuDelegate> _delegate;
  NSArray *_selectedItems;
}

@property (readwrite, nonatomic, retain) id<ILFinderMenuDelegate> delegate;
@property (readonly, nonatomic) NSArray *selectedItems;

+ (ILFinderMenu *)sharedInstance;

@end
