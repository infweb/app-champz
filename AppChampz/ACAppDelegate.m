//
//  ACAppDelegate.m
//  AppChampz
//
//  Created by Rodolfo Carvalho on 1/15/13.
//  Copyright (c) 2013 iNF Web. All rights reserved.
//

#import "ACAppDelegate.h"
#import "GAI.h"

#define TEST_FLIGHT_TEAM_TOKEN @"8e1df1db4b06191b53a5cee187e3c370_MTc3OTc3MjAxMy0wMS0yMiAwNjoxMDo1Ni4zOTE2ODU"

#define kGoogleAnalyticsTrackingID @"UA-31056501-3"

@implementation ACAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].debug = YES;
    
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID];
    NSLog(@"Registered tracker %@", tracker);
    
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:TEST_FLIGHT_TEAM_TOKEN];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIImageView *splash = [[UIImageView alloc]
                               initWithImage:[UIImage imageNamed:@"Default.png"]];
        [self.window.rootViewController.view addSubview:splash];
        [UIView animateWithDuration:0.5
                         animations:^{
                             splash.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [splash removeFromSuperview];
                         }];
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end