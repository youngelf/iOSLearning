//
//  CEVAppDelegate.m
//  Hypnosister
//
//  Created by Jimi on 6/25/14.
//  Copyright (c) 2014 Jimi. All rights reserved.
//

#import "CEVAppDelegate.h"
#import "CEVHypnosisView.h"

@implementation CEVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    // Put it inside a scrollview that is twice as big as the screen.
    CGRect screenRect = [[self window] bounds];

    // Create a screen-sized scroll view.
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:screenRect];
    [self.window addSubview:scroll];
    [scroll setDelegate:self];
    [scroll setMaximumZoomScale:4.0];
    [scroll setMinimumZoomScale:0.50];
    
    // Silver challenge, make the screen bigger and allow pinch-to-zoom.
    CGRect fourTimesAsBig = screenRect;
    fourTimesAsBig.size.width *= 2.0;
    fourTimesAsBig.size.height *= 2.0;

    // Two hypno views, each as big as the screen.
    [self setHypnoView:[[CEVHypnosisView alloc] initWithFrame:fourTimesAsBig]];
    [scroll addSubview:[self hypnoView]];

    // Let's not add the second view here for the silver challenge.
    const BOOL twoViewsOnly = NO;
    // This one has to be offset from the first
    if (twoViewsOnly) {
        screenRect.origin.x += screenRect.size.width;
        CEVHypnosisView *hynoView2 = [[CEVHypnosisView alloc] initWithFrame:screenRect];
        //    [view setBackgroundColor:[UIColor whiteColor]];
        [scroll addSubview:hynoView2];

        // Set the bounds of the scroll container: twice as wide.
        CGRect twiceAsWide = screenRect;
        twiceAsWide.size.width *= 2.0;
        //	 [scroll setPagingEnabled:YES];
        [scroll setContentSize:twiceAsWide.size];
    }

    [scroll setContentSize:fourTimesAsBig.size];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self hypnoView];
}

@end
