//
//  AppDelegate.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "AppDelegate.h"

#import "TripsViewController.h"
#import "PersistentStack.h"

#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property (nonatomic, strong) PersistentStack* persistentStack;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    TripsViewController *controller = (TripsViewController *)navigationController.topViewController;
    self.persistentStack = [[PersistentStack alloc] init];
    controller.managedObjectContext = self.persistentStack.managedObjectContext;
    
    application.applicationSupportsShakeToEdit = YES;
    
    [Crashlytics startWithAPIKey:@"4085d67bba35160ce0438f0ad3b251a9eee8334d"];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.persistentStack saveContext];
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
