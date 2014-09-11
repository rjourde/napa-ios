//
//  NewTripViewController.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "NewEditTripViewController.h"

#import "NewEditTripDataSource.h"
#import "TripViewController.h"
#import "TextFieldCell.h"

#define kDatePickerTag  99     // view tag identifiying the date picker view

@interface NewEditTripViewController ()

@property (nonatomic, strong) NewEditTripDataSource *tripDataSource;

@property (assign) NSInteger pickerCellRowHeight;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation NewEditTripViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.editModeON = NO;
    }
    return self;
}

- (void)InitializeDataSource
{
    Trip *trip = (Trip *)self.objectToEdit;
    
    if (self.editModeON && trip)
    {
        self.tripDataSource = [[NewEditTripDataSource alloc] initWithTripName:trip.name
                                                                    startDate:trip.startDate
                                                                      endDate:trip.endDate];
    }
    else
    {
        self.tripDataSource = [[NewEditTripDataSource alloc] initWithTripName: @""
                                                                    startDate:[NSDate date]
                                                                      endDate:[NSDate date]];
    }
    
    self.tableView.dataSource = self.tripDataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.editModeON)
    {
        self.navigationItem.title = @"New Trip";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self InitializeDataSource];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height;
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.editModeON) {
        [self.tripDataSource.nameTextField becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissKeyboard
{
    [self.view removeGestureRecognizer:self.tap];
    [self.tripDataSource.nameTextField resignFirstResponder];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - DatePicker

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if ([self.tripDataSource hasInlineDatePicker])
    {
        NSIndexPath *datePickerIndexPath = self.tripDataSource.datePickerIndexPath;
        
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = [self.tripDataSource itemAtIndex: datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self.tripDataSource indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:kDateSection]];
    
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    BOOL sameCellClicked = NO;
    if ([self.tripDataSource hasInlineDatePicker])
    {
        before = self.tripDataSource.datePickerIndexPath.row < indexPath.row;
        sameCellClicked = (self.tripDataSource.datePickerIndexPath.row - 1 == indexPath.row);
    }
    
    // remove any date picker cell if it exists
    if ([self.tripDataSource hasInlineDatePicker])
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.tripDataSource.datePickerIndexPath.row
                                                                    inSection:kDateSection]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.tripDataSource.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:kDateSection];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.tripDataSource.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:kDateSection];
    }
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
	[self.delegate newTripViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
    NSDate *startDate = [[self.tripDataSource itemAtIndex:kDateStartRow] valueForKey:kDateKey];
    NSDate *endDate = [[self.tripDataSource itemAtIndex:kDateEndRow] valueForKey:kDateKey];
    
    // Before creating a new trip, check if the dates are valid
    if([endDate isEarlierThan:startDate])
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Trip cannot be saved"
                                                          message:@"Start date must be earlier than end date."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    else
    {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:kNameSection];
        TextFieldCell *cell = (TextFieldCell *)[self.tableView cellForRowAtIndexPath:cellIndexPath];
        
        Trip* trip;
        // Create new trip
        if (!self.editModeON) {
            trip = [Trip insertTripWithName:cell.textField.text
                                  startDate:startDate
                                    endDate:endDate
                     inManagedObjectContext:self.managedObjectContext];
        }
        // Edit trip
        else
        {
            trip = (Trip *)self.objectToEdit;
            trip.name = cell.textField.text;
            trip.startDate = startDate;
            trip.endDate = endDate;
        }
        
        [self.delegate newTripViewController:self didDoneWithTrip:trip];
    }
}

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSIndexPath *datePickerIndexPath = self.tripDataSource.datePickerIndexPath;
    
    // update the cell's date "above" the date picker cell
    NSIndexPath *targetedCellIndexPath = [NSIndexPath indexPathForRow:datePickerIndexPath.row - 1 inSection:kDateSection];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = [self.tripDataSource itemAtIndex:targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [dateFormatter stringFromDate:targetedDatePicker.date];
    
    // Start date must be earlier than end date
    NSDate *startDate = [[self.tripDataSource itemAtIndex:kDateStartRow] valueForKey:kDateKey];
    NSDate *endDate = [[self.tripDataSource itemAtIndex:kDateEndRow] valueForKey:kDateKey];
    
    // update end date cell if start date picker is active
    if(datePickerIndexPath.row - 1 == kDateStartRow && [startDate isLaterThan:endDate])
    {
        // update the end date cell
        NSIndexPath *endDateCellIndexPath = [NSIndexPath indexPathForRow:datePickerIndexPath.row + 1 inSection:kDateSection];
        UITableViewCell *endDatecell = [self.tableView cellForRowAtIndexPath:endDateCellIndexPath];
        endDatecell.detailTextLabel.text = [dateFormatter stringFromDate:targetedDatePicker.date];
        
        // update date array with new date
        NSMutableDictionary *itemData = [self.tripDataSource itemAtIndex:kDateEndRow];
        [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    }
    
    // add strike through end date cell if end date picker is active
    if(datePickerIndexPath.row - 1 == kDateEndRow && [endDate isEarlierThan:startDate])
    {
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:cell.detailTextLabel.text];
         [attributeString addAttribute:NSStrikethroughStyleAttributeName value:@1 range:NSMakeRange(0, [attributeString length])];
         cell.detailTextLabel.attributedText = attributeString;
    }
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:self.tap];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view removeGestureRecognizer:self.tap];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.tripDataSource.nameTextField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isFieldEmpty = [newText isEqualToString:@""];
    self.navigationItem.rightBarButtonItem.enabled = !isFieldEmpty;
    
	return YES;
}

@end
