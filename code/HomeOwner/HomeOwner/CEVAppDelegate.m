//
//  CEVAppDelegate.m
//  HomeOwner
//
//  Created by Jimi on 7/16/14.
//  Copyright (c) 2014 Eggwall. All rights reserved.
//

#import "CEVAppDelegate.h"
#import "CEVItemsViewController.h"
#import "CEVDetailViewController.h"
#import "CEVItemStore.h"

@implementation CEVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // Create a Table view controller and set it as the root controller.
    
    // Now put a UINavigationViewController and include the ItemViewController as its first element.
    UINavigationController *navController = [[UINavigationController alloc] init];
    
    // The list view.
    CEVItemsViewController *itemController = [[CEVItemsViewController alloc] init];

    [navController setViewControllers:@[itemController]];
    
    // And add the UINavController as the root controller
    [[self window] setRootViewController:navController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    NSLog(@"applicationDidFinishLaunchingWithOption");

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // Save the item store to disk here
    BOOL isStored = [[CEVItemStore sharedStore] saveToDisk];
    NSLog(@"Stored successfully: %@", isStored ? @"YES" : @"NO");
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");
}

@end
