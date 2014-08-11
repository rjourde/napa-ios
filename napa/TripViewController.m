//
//  TripViewController.m
//  napa
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "TripViewController.h"

@interface TripViewController ()

@end

@implementation TripViewController

#pragma mark - Managing the trip

- (void)setTrip:(Trip*)newTrip
{
    if (_trip != newTrip) {
        _trip = newTrip;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.trip) {
        self.navigationItem.title = self.trip.name;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
