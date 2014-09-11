//
//  NewEditTripViewControllerDataSource.h
//  napa
//
//  Created by Remy JOURDE on 05/09/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "Trip.h"

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

#define kNameSection    0
#define kDateSection    1

// keep track of which rows have date cells
#define kDateStartRow   0
#define kDateEndRow     1

static NSString *kNameCellID = @"nameCell";     // the cell containing the text field
static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker

@interface NewEditTripDataSource : NSObject <UITableViewDataSource>

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, strong) UITextField *nameTextField; // textfield of the name cell

- (id)initWithTripName:(NSString *)tripName startDate:(NSDate *) startDate endDate:(NSDate *)endDate;
- (id)itemAtIndex:(NSInteger)index;
- (BOOL)hasInlineDatePicker;
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath;

@end
