//
//  MasterViewController.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "TripsViewController.h"

#import "TripsViewControllerDataSource.h"
#import "NewEditTripViewController.h"
#import "DetailViewController.h"
#import "Trip.h"
#import "TripViewCell.h"

static NSString *kShowTripSegue     = @"showTrip";
static NSString *kNewTripSegue      = @"newTrip";
static NSString *kEditTripSegue     = @"editTrip";

#define kDeleteButtonIndex      0
#define kEditButtonIndex        1
#define kCancelButtonIndex      2

@interface TripsViewController () <TripsViewControllerDataSourceDelegate, NewEditTripViewControllerDelegate>

@property (nonatomic, strong) TripsViewControllerDataSource* tripsViewControllerDataSource;

// keep track of the selected collection view cell
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) Trip *currentTrip;

- (void)editTrip;
- (void)deleteTrip;

@end

@implementation TripsViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupFetchedResultsController];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        
        self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
        if (self.selectedIndexPath == nil)
        {
            NSLog(@"couldn't find index path");
        }
        else
        {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Delete Trip"
                                                            otherButtonTitles:@"Edit Trip", nil];
            [actionSheet showInView:self.view];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFetchedResultsController
{
    self.tripsViewControllerDataSource = [[TripsViewControllerDataSource alloc] initWithCollectionView:self.collectionView];
    self.tripsViewControllerDataSource.fetchedResultsController = [Trip tripsFetchedResultsControllerInManagedObjectContext:self.managedObjectContext];
    self.tripsViewControllerDataSource.delegate = self;
}

#pragma mark - Fetched Results Controller Delegate

- (void)configureCell:(id)theCell withObject:(id)object
{
    TripViewCell* cell = theCell;
    Trip* trip = object;
    cell.nameLabel.text = trip.name;
    
    NSInteger days = [trip.startDate numberOfDaysUntilDay:trip.endDate];
    
    if (days <= 1) {
        cell.daysLabel.text = [NSString stringWithFormat:@"1 day"];
    }
    else
    {
        cell.daysLabel.text = [NSString stringWithFormat:@"%ld days", days];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    cell.dateLabel.text = [dateFormatter stringFromDate:trip.startDate];
    
    [dateFormatter setDateFormat:@"MMM"];
    cell.monthLabel.text = [dateFormatter stringFromDate:trip.startDate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([segue.identifier isEqualToString:kShowTripSegue])
    {
        if (!self.currentTrip)
        {
            [self presentTripViewController:segue.destinationViewController];
        }
        else
        {
            [(DetailViewController*)segue.destinationViewController setDetailItem:self.currentTrip];
            self.currentTrip = nil;
        }
    }
    if ([segue.identifier isEqualToString:kNewTripSegue])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        NewEditTripViewController *newTripViewController = [[navigationController viewControllers] objectAtIndex:0];
        newTripViewController.managedObjectContext = self.managedObjectContext;
        newTripViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:kEditTripSegue])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        NewEditTripViewController *editTripViewController = [[navigationController viewControllers] objectAtIndex:0];
        editTripViewController.managedObjectContext = self.managedObjectContext;
        editTripViewController.editModeON = YES;
        editTripViewController.objectToEdit = [self.tripsViewControllerDataSource itemAtIndexPath:self.selectedIndexPath];
        editTripViewController.delegate = self;
    }
}

- (void)presentTripViewController:(DetailViewController*)tripViewController
{
    NSManagedObject *object = [self.tripsViewControllerDataSource selectedItem];
    [tripViewController setDetailItem:object];
}

#pragma mark - NewTripViewController delegate

- (void)newTripViewControllerDidCancel:(NewEditTripViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newTripViewController:(NewEditTripViewController *)controller didDoneWithTrip:(Trip*) trip
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.currentTrip = trip;
    [self performSegueWithIdentifier:kShowTripSegue sender:self];
}

#pragma mark - UIActionSheet deletegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case kDeleteButtonIndex:
            [self deleteTrip];
            break;
        case kEditButtonIndex:
            [self editTrip];
        default:
            break;
    }
}

- (void)editTrip
{
    [self performSegueWithIdentifier:kEditTripSegue sender:self];
}

- (void)deleteTrip
{
	Trip *trip = [self.tripsViewControllerDataSource itemAtIndexPath:self.selectedIndexPath];
    NSString* actionName = [NSString stringWithFormat:@"%@ trip deletion", trip.name];
    [self.undoManager setActionName:actionName];
    [self.managedObjectContext deleteObject:trip];
}

#pragma mark - Undo

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSUndoManager*)undoManager
{
    return self.managedObjectContext.undoManager;
}

@end
