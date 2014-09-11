//
//  NewEditTripViewControllerDataSource.m
//  napa
//
//  Created by Remy JOURDE on 05/09/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "NewEditTripDataSource.h"

#import "TextFieldCell.h"

@interface NewEditTripDataSource ()

@property (nonatomic, strong) NSString *tripName;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation NewEditTripDataSource

- (id)initWithTripName:(NSString *)tripName startDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self.tripName = tripName;
    
    NSMutableDictionary *itemOne = [@{ kTitleKey : @"Start Date", kDateKey : startDate } mutableCopy];
    NSMutableDictionary *itemTwo = [@{ kTitleKey : @"End Date", kDateKey : endDate } mutableCopy];
    
    self.dataArray = @[itemOne, itemTwo];
    
    return self;
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow /*|| ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))*/))
    {
        hasDate = YES;
    }
    
    return hasDate;
}

- (id)itemAtIndex:(NSInteger)index
{
    return self.dataArray[index];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == kNameSection)
    {
        return 1;
    }
    else
    {
        if ([self hasInlineDatePicker])
        {
            // we have a date picker, so allow for it in the number of rows in this section
            NSInteger numRows = self.dataArray.count;
            return ++numRows;
        }
        
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == kNameSection)
    {
        TextFieldCell *textFieldCell = (TextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kNameCellID];
        textFieldCell.textField.text = self.tripName;
        self.nameTextField = textFieldCell.textField;
        
        return textFieldCell;
    }
    // need to do this only for the date section
    NSString *cellID = @"";
    if ([self indexPathHasPicker:indexPath])
    {
        // the indexPath is the one containing the inline date picker
        cellID = kDatePickerID;     // the current/opened date picker cell
    }
    else if ([self indexPathHasDate:indexPath])
    {
        // the indexPath is one that contains the date information
        cellID = kDateCellID;       // the start/end date cells
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // if we have a date picker open whose cell is above the cell we want to update,
    // then we have one more cell than the model allows
    NSInteger modelRow = indexPath.row;
    if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row < indexPath.row)
    {
        modelRow--;
    }
    
    NSDictionary *itemData = nil;
    if(![indexPath isEqual:self.datePickerIndexPath])
    {
        itemData = self.dataArray[modelRow];
    }
    
    // proceed to configure our cell
    if ([cellID isEqualToString:kDateCellID])
    {
        // we have either start or end date cells, populate their date field
        cell.textLabel.text = [itemData valueForKey:kTitleKey];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        cell.detailTextLabel.text = [dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
        cell.detailTextLabel.textColor = cell.textLabel.textColor;
    }
    
	return cell;
}

@end
