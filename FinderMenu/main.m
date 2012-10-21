//
//  main.m
//  FinderMenu
//
//  Created by Alexey Zhuchkov on 10/21/12.
//  Copyright (c) 2012 InfiniteLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "mach_inject_bundle/mach_inject_bundle.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        pid_t pid = 100;  // TODO: get Finder pid

        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"FinderExt" ofType:@"bundle"];
        
        NSLog(@"Bundle path: %@", bundlePath);
        NSLog(@"PID: %d", pid);
        
        mach_error_t err;
        err = mach_inject_bundle_pid([bundlePath fileSystemRepresentation], pid);
        NSLog(@"Inject result: %d", err);
    }
    return 0;
}

