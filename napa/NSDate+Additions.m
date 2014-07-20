//
//  NSDate+Additions.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

const NSInteger secondPerMunite = 60;
const NSInteger munitePerHour = 60;
const NSInteger hourPerDay = 24;

- (BOOL)isLaterThanOrEqualTo:(NSDate*)date
{
    return !([self compare:date] == NSOrderedAscending);
}

- (BOOL)isEarlierThanOrEqualTo:(NSDate*)date
{
    return !([self compare:date] == NSOrderedDescending);
}

- (BOOL)isLaterThan:(NSDate*)date
{
    return ([self compare:date] == NSOrderedDescending);
    
}

- (BOOL)isEarlierThan:(NSDate*)date
{
    return ([self compare:date] == NSOrderedAscending);
}

- (NSInteger)numberOfDaysUntilDay:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:self
                                                  toDate:date options:0];
    
    return [components day];
}

@end
