//
//  AppDelegate.m
//  CMVideoRecordDemo
//
//  Created by 宋国华 on 2019/4/9.
//  Copyright © 2019 MPM. All rights reserved.
//

#define NOTIFICATION_RESIGN_ACTIVE              @"appResignActive"
#define NOTIFICATION_BECOME_ACTIVE              @"appBecomeActive"

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //进入后台时调用
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RESIGN_ACTIVE object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //从后台进入程序时调用
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BECOME_ACTIVE object:nil];
}

@end
