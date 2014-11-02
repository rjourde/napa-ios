//
//  PersistentStack.swift
//  napa
//
//  Created by Remy JOURDE on 29/09/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import CoreData

class PersistentStack: NSObject {
    
    var managedObjectModel : NSManagedObjectModel?
    var persistentStoreCoordinator: NSPersistentStoreCoordinator?
    var managedObjectContext: NSManagedObjectContext?
    
    override init() {
        super.init()
        
        if let modelURL = NSBundle.mainBundle().URLForResource("napa", withExtension: "momd") {
            if let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) {
                persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                
                var error: NSError?
                
                let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("napa_1.5.sqlite")
                
                persistentStoreCoordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &error)
                
                managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
                managedObjectContext!.persistentStoreCoordinator = persistentStoreCoordinator
                managedObjectContext!.undoManager = NSUndoManager()
            }
        }
    }
    
    func saveContext() {
        var error: NSError?
        
        if let managedObjectContext = self.managedObjectContext {
            if managedObjectContext.hasChanges && !managedObjectContext.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                println("error saving context: \(error)")
                abort();
            }
        }
    }
    
    // Mark: - Application's Documents directory
    
    // Returns the URL to the application's Documents directory.
    func applicationDocumentsDirectory() -> NSURL {
        let directory = NSSearchPathDirectory.DocumentDirectory
        let domains = NSSearchPathDomainMask.UserDomainMask
        
        return NSFileManager.defaultManager().URLsForDirectory(directory, inDomains: domains).last as NSURL
    }
}
