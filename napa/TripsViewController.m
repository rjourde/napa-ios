//
//  MasterViewController.m
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "TripsViewController.h"

#import "TripsViewControllerDataSource.h"
#import "DetailViewController.h"
#import "Trip.h"
#import "TripViewCell.h"

static NSString *kShowTripSegue = @"showTrip";
static NSString *kNewTripSegue = @"newTrip";
static NSString *kEditTripSegue = @"editTrip";

#define kDeleteButtonIndex      0
#define kEditButtonIndex        1
#define kCancelButtonIndex      2

@interface TripsViewController () <TripsViewControllerDataSourceDelegate, NewEditTripViewControllerDelegate>

@property (nonatomic, strong) TripsViewControllerDataSource* tripsViewControllerDataSource;

// keep track of the selected collection view cell
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

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
    
    [self.navigationController setToolbarHidden:YES animated:NO];
	
    [self setupFetchedResultsController];
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .5; //seconds
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
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
    
    cell.daysLabel.text = [NSString stringWithFormat:@"%ld days", [trip.startDate numberOfDaysUntilDay:trip.endDate]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    cell.dateLabel.text = [dateFormatter stringFromDate:trip.startDate];
    
    [dateFormatter setDateFormat:@"MMM"];
    cell.monthLabel.text = [dateFormatter stringFromDate:trip.startDate];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:kShowTripSegue]) {
        [self presentTripViewController:segue.destinationViewController];
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

- (void)newTripViewControllerDidDone:(NewEditTripViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //TODO: push newly created trip
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
	NSManagedObject *object = [self.tripsViewControllerDataSource itemAtIndexPath:self.selectedIndexPath];
    [self.managedObjectContext deleteObject:object];
}

@end
