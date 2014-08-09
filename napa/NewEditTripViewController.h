//
//  NewTripViewController.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Trip.h"

@class NewEditTripViewController;

@protocol NewEditTripViewControllerDelegate <NSObject>
- (void)newTripViewControllerDidCancel:(NewEditTripViewController *)controller;
- (void)newTripViewController:(NewEditTripViewController *)controller didDoneWithTrip:(Trip *)trip;
@end

@interface NewEditTripViewController : UITableViewController

@property (nonatomic, weak) id <NewEditTripViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSManagedObject* objectToEdit;
@property (nonatomic) bool editModeON;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

