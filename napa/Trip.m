//
//  Trip.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "Trip.h"

@implementation Trip

@dynamic name;
@dynamic startDate;
@dynamic endDate;
@dynamic sectionIdentifier;

+ (instancetype)insertTripWithName:(NSString*)name
                         startDate:(NSDate*)startDate
                           endDate:(NSDate*)endDate
            inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    Trip* trip = [NSEntityDescription insertNewObjectForEntityForName:[self.class entityName]
                                               inManagedObjectContext:managedObjectContext];
    trip.name = name;
    trip.startDate = startDate;
    trip.endDate = endDate;
    return trip;
}

+(NSString*)entityName
{
    return @"Trip";
}

+ (NSFetchedResultsController *)tripsFetchedResultsControllerInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    // Set the batch size to a suitable number.
    request.fetchBatchSize= 20;
    // Edit the sort key as appropriate.
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    // Use the sectionIdentifier property to group into sections.
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                               managedObjectContext:managedObjectContext
                                                 sectionNameKeyPath:@"sectionIdentifier"
                                                          cacheName:nil];
}

#pragma mark - Transient properties

- (NSString *)sectionIdentifier
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    return [dateFormatter stringFromDate:self.startDate];
}

#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of start date changes, the section identifier may change as well.
    return [NSSet setWithObject:@"startDate"];
}

@end
