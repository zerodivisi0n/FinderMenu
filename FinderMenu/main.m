//
//  main.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "mach_inject_bundle/mach_inject_bundle.h"

int main(int argc, const char * argv[])
{
  @autoreleasepool {
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.finder"];
    if ([apps count] < 1) {
      NSLog(@"Finder not found");
      return -1;
    }
    
    // Use first found app
    pid_t pid = [[apps objectAtIndex:0] processIdentifier];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FinderExt" ofType:@"bundle"];
    
    NSLog(@"Bundle path: %@", bundlePath);
    NSLog(@"PID: %d", pid);
    
    mach_error_t err;
    err = mach_inject_bundle_pid([bundlePath fileSystemRepresentation], pid);
    if (err == err_none) {
      NSLog(@"Inject successful!");
    } else {
      NSLog(@"Inject error: %d", err);
    }
  }
  return 0;
}

