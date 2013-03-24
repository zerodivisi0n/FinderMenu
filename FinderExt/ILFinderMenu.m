//
//  ILFinderMenu.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 3/23/13.
//  Copyright (c) 2013 InfiniteLabs. All rights reserved.
//

#import "ILFinderMenu.h"

#import "Finder.h"
#import "ILClassOverrideUtils.h"
#import "ILTFENodeUtils.h"

static int osxMajorVersion()
{
  NSDictionary *sv = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/CoreServices/SystemVersion.plist"];
  NSArray *versionComponents = [[sv objectForKey:@"ProductVersion"] componentsSeparatedByString:@"."];
  return [[versionComponents objectAtIndex:1] intValue];
}

@interface ILFinderMenu ()
@property (readwrite, nonatomic, retain) NSArray *selectedItems;
@end

@implementation ILFinderMenu

@synthesize delegate = _delegate;
@synthesize selectedItems = _selectedItems;

static ILFinderMenu *_sharedInstance = nil;

+ (ILFinderMenu *)sharedInstance
{
  @synchronized (self) {
    if (!_sharedInstance) {
      _sharedInstance = [[ILFinderMenu alloc] init];
    }
  }
  return _sharedInstance;
}

- (id)init
{
  self = [super init];
  if (self) {
    int versionMajor = osxMajorVersion();
    if (versionMajor < 6) {
      // Versions earlier Snow Leopard is not supported
      [self release];
      return nil;
    }
    
    Class menuClass = NSClassFromString(@"TContextMenu");
    if (!menuClass) {
      [self release];
      return nil;
    }
    
    if (versionMajor >= 8) {
      // Mountain Lion and greater
      overrideClassMethod(menuClass,
                          @selector(handleContextMenuCommon:nodes:event:view:browserController:addPlugIns:),
                          [self class],
                          @selector(override_TContextMenu_handleContextMenuCommon:nodes:event:view:browserController:addPlugIns:));
      overrideInstanceMethod(menuClass,
                             @selector(configureWithNodes:browserController:container:),
                             [self class],
                             @selector(override_TContextMenu_configureWithNodes:browserController:container:));
    } else {
      // Snow Leopard & Lion
      overrideClassMethod(menuClass,
                          @selector(handleContextMenuCommon:nodes:event:view:windowController:addPlugIns:),
                          [self class],
                          @selector(override_TContextMenu_handleContextMenuCommon:nodes:event:view:windowController:addPlugIns:));
      overrideInstanceMethod(menuClass,
                             @selector(configureWithNodes:windowController:container:),
                             [self class],
                             @selector(override_TContextMenu_configureWithNodes:windowController:container:));
    }
    overrideClassMethod(menuClass,
                        @selector(addViewSpecificStuffToMenu:browserViewController:context:),
                        [self class],
                        @selector(override_TContextMenu_addViewSpecificStuffToMenu:browserViewController:context:));
  }
  return self;
}

+ (void)finderWillShowContextMenu:(id)menu
{
  [[[self sharedInstance] delegate] finderWillShowContextMenu:menu];
}

+ (void)setSelectedItemsFromNodes:(const struct TFENodeVector *)nodes
{
  [[self sharedInstance] setSelectedItems:pathsForNodes(nodes)];
}

#pragma mark Override methods for icons and desktop views
// Snow Leopard & Lion
+ (void)override_TContextMenu_handleContextMenuCommon:(unsigned int)context
                                                nodes:(const struct TFENodeVector *)nodes
                                                event:(id)event
                                                 view:(id)view
                                     windowController:(id)windowController
                                           addPlugIns:(BOOL)flag
{
  [ILFinderMenu setSelectedItemsFromNodes:nodes];
  [self override_TContextMenu_handleContextMenuCommon:context
                                                nodes:nodes
                                                event:event
                                                 view:view
                                     windowController:windowController
                                           addPlugIns:flag];
}

// Mountain Lion
+ (void)override_TContextMenu_handleContextMenuCommon:(unsigned int)context
                                                nodes:(const struct TFENodeVector *)nodes
                                                event:(id)event
                                                 view:(id)view
                                    browserController:(id)browserController
                                           addPlugIns:(BOOL)flag
{
  [ILFinderMenu setSelectedItemsFromNodes:nodes];
  [self override_TContextMenu_handleContextMenuCommon:context
                                                nodes:nodes
                                                event:event
                                                 view:view
                                    browserController:browserController
                                           addPlugIns:flag];
}

// Snow Leopard, Lion & Mountain Lion
+ (void)override_TContextMenu_addViewSpecificStuffToMenu:(id)menu
                                   browserViewController:(id)browserViewController
                                                 context:(unsigned int)context
{
  [self override_TContextMenu_addViewSpecificStuffToMenu:menu
                                   browserViewController:browserViewController
                                                 context:context];
  
  // Update menu only for Desktop and Icon views
  if ([browserViewController isKindOfClass:NSClassFromString(@"TIconViewController")]
      || [browserViewController isKindOfClass:NSClassFromString(@"TDesktopViewController")]) {
    [ILFinderMenu finderWillShowContextMenu:menu];
  }
}

#pragma mark Override methods for list, columns and cover flow views
// Snow Leopard & Lion
- (void)override_TContextMenu_configureWithNodes:(const struct TFENodeVector *)nodes
                                windowController:(id)windowController
                                       container:(BOOL)container
{
  [self override_TContextMenu_configureWithNodes:nodes
                                windowController:windowController
                                       container:container];
  
  [ILFinderMenu setSelectedItemsFromNodes:nodes];
  [ILFinderMenu finderWillShowContextMenu:self];
}

// Mountain Lion
- (void)override_TContextMenu_configureWithNodes:(const struct TFENodeVector *)nodes
                               browserController:(id)browserController
                                       container:(BOOL)container
{
  [self override_TContextMenu_configureWithNodes:nodes
                               browserController:browserController
                                       container:container];
  
  [ILFinderMenu setSelectedItemsFromNodes:nodes];
  [ILFinderMenu finderWillShowContextMenu:self];
}

@end
