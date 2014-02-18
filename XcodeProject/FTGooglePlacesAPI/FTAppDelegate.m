//
//  FTAppDelegate.m
//  FTGooglePlacesAPI
//
//  Created by Lukas Kukacka on 19/11/13.
//  Copyright (c) 2013 Fuerte Int. Ltd. All rights reserved.
//

#import "FTAppDelegate.h"

#import "FTGooglePlacesAPIExamplesListViewController.h"

#import "FTGooglePlacesAPI.h"

@implementation FTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rootController = [[FTGooglePlacesAPIExamplesListViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
#warning Possible incomplete implementation. Make sure you add you own Google Places API key
    [FTGooglePlacesAPIService provideAPIKey:@"<#PLACE YOUR API KEY HERE#>"];
    
    self.window.rootViewController = navController;
    
    [self createAttributionsViews];
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

#pragma mark - Helper methods

- (void)createAttributionsViews
{
    UIView *containerView = self.window.rootViewController.view;
    
    //  To comply with Google Places API Policies at https://developers.google.com/places/policies
    //  we display "Powered by Google" logo. For simplicity, it is simply added as a subview
    //  to root controller's view. This ensures the logo is always visible.
    UIImage *googleLogo = [UIImage imageNamed:@"powered-by-google-on-white"];
    UIImageView *googleLogoView = [[UIImageView alloc] initWithImage:googleLogo];
    googleLogoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    googleLogoView.userInteractionEnabled = NO;
    googleLogoView.opaque = NO;
    
    CGRect googleLogoFrame = googleLogoView.frame;
    googleLogoFrame.origin = CGPointMake(10.0f,
                                         CGRectGetHeight(containerView.frame) - googleLogo.size.height - 10.0f);
    googleLogoView.frame = googleLogoFrame;
    
    [containerView addSubview:googleLogoView];
}

@end
