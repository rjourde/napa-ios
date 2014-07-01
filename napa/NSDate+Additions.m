//
//  NSDate+Additions.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (BOOL) isLaterThanOrEqualTo:(NSDate*)date
{
    return !([self compare:date] == NSOrderedAscending);
}

- (BOOL) isEarlierThanOrEqualTo:(NSDate*)date
{
    return !([self compare:date] == NSOrderedDescending);
}

- (BOOL) isLaterThan:(NSDate*)date
{
    return ([self compare:date] == NSOrderedDescending);
    
}

- (BOOL) isEarlierThan:(NSDate*)date
{
    return ([self compare:date] == NSOrderedAscending);
}

@end
