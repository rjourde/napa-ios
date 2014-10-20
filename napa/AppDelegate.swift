//
//  AppDelegate.swift
//  napa
//
//  Created by Remy JOURDE on 29/09/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var persistentStack = PersistentStack()
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        let navigationController = self.window?.rootViewController as UINavigationController
        
        let controller: TripsViewController = navigationController.topViewController as TripsViewController
        controller.managedObjectContext = self.persistentStack.managedObjectContext
        
        application.applicationSupportsShakeToEdit = true;
        
        //[Crashlytics startWithAPIKey:@"4085d67bba35160ce0438f0ad3b251a9eee8334d"];
        
        return true;
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
        self.persistentStack.saveContext()
    }
    
    func applicationShouldRestoreApplicationState(coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationShouldSaveApplicationState(coder: NSCoder) -> Bool {
        return true
    }
}
