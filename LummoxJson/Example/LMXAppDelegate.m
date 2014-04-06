//
//  LMXAppDelegate.m
//  LummoxJson
//
//  Created by Michael Busheikin on 2014-04-04.
//  Copyright (c) 2014 Lummox Labs. All rights reserved.
//

#import "LMXAppDelegate.h"
#import "LMXViewController.h"

@implementation LMXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *viewController = [[LMXViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
