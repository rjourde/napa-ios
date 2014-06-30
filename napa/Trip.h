//
//  Trip.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Trip : NSManagedObject

@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;

+(instancetype)insertTripWithName:(NSString*)name
                         startDate:(NSDate*)startDate
                           endDate:(NSDate*)endDate
            inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+(NSFetchedResultsController*)tripsFetchedResultsControllerInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
