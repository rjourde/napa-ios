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
static NSString *knewTripSegue = @"newTrip";

@interface TripsViewController () <TripsViewControllerDataSourceDelegate, NewTripViewControllerDelegate>

@property (nonatomic, strong) TripsViewControllerDataSource* tripsViewControllerDataSource;

@end

@implementation TripsViewController


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupFetchedResultsController];
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

#pragma mark Fetched Results Controller Delegate

- (void)configureCell:(id)theCell withObject:(id)object
{
    TripViewCell* cell = theCell;
    Trip* trip = object;
    cell.nameLabel.text = trip.name;
    [cell setIcon:[UIImage imageWithData:[object valueForKey:@"icon"]]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:kShowTripSegue]) {
        [self presentTripViewController:segue.destinationViewController];
    }
    if ([segue.identifier isEqualToString:knewTripSegue])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        NewTripViewController *newTripViewController = [[navigationController viewControllers] objectAtIndex:0];
        newTripViewController.managedObjectContext = self.managedObjectContext;
        newTripViewController.delegate = self;
    }
}

- (void)presentTripViewController:(DetailViewController*)tripViewController
{
    NSManagedObject *object = [self.tripsViewControllerDataSource selectedItem];
    [tripViewController setDetailItem:object];
}

#pragma mark - NewTripViewController delegate

- (void)newTripViewControllerDidCancel:(NewTripViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newTripViewControllerDidDone:(NewTripViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // push newly created trip
}

@end
