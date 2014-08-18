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

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@property (nonatomic) NSString *sectionIdentifier;

+ (instancetype)insertTripWithName:(NSString*)name
                         startDate:(NSDate*)startDate
                           endDate:(NSDate*)endDate
            inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSFetchedResultsController*)tripsFetchedResultsControllerInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
