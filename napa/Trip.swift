//
//  Trip.swift
//  napa
//
//  Created by Remy JOURDE on 29/09/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import CoreData

class Trip: NSManagedObject {
    var name = "new Trip"
    var startDate = NSDate.date()
    var endDate = NSDate.date()
    var sectionIdentifier: String {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY"
            return dateFormatter.stringFromDate(self.startDate)
        }
    }
    
    init(name: String, startDate: NSDate, endDate: NSDate) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
    
    class func insertTripWithName( name: String,
                              startDate: NSDate,
                                endDate: NSDate,
                   inManagedObjectContext: NSManagedObjectContext) -> Trip {
        var trip = NSEntityDescription.insertNewObjectForEntityForName(self.entityName(), inManagedObjectContext: inManagedObjectContext) as Trip
        trip.name = name
        trip.startDate = startDate
        trip.endDate = endDate
        
        return trip
    }
    
    class func entityName() -> String {
        return "Trip";
    }
    
    class func tripsFetchedResultsControllerInManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> NSFetchedResultsController {
    
        let request = NSFetchRequest(entityName: self.entityName())
        // Set the batch size to a suitable number.
        request.fetchBatchSize = 20;
        // Edit the sort key as appropriate.
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending:true)]
        // Use the sectionIdentifier property to group into sections.
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext,  sectionNameKeyPath: "sectionIdentifier", cacheName:nil)
    }
    
    // MARK: - Key path dependencies
    
    class func keyPathsForValuesAffectingSectionIdentifier() -> NSSet {
        // If the value of start date changes, the section identifier may change as well.
        return NSSet(objects: "startDate")
    }
}
