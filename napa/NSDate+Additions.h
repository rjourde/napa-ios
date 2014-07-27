//
//  NSDate+Additions.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions);
- (BOOL)isLaterThan:(NSDate*)date;
- (BOOL)isEarlierThan:(NSDate*)date;
- (NSInteger)numberOfDaysUntilDay:(NSDate *)date;
@end
