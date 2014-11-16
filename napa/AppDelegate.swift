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
    
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        let navigationController = self.window?.rootViewController as UINavigationController
        
        return true;
    }
    
    func applicationDidEnterBackground(application: UIApplication!) {
    }
    
    func applicationShouldRestoreApplicationState(coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationShouldSaveApplicationState(coder: NSCoder) -> Bool {
        return true
    }
}
