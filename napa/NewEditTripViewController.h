//
//  NewTripViewController.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewEditTripViewController;

@protocol NewEditTripViewControllerDelegate <NSObject>
- (void)newTripViewControllerDidCancel:(NewEditTripViewController *)controller;
- (void)newTripViewControllerDidDone:(NewEditTripViewController *)controller;
@end

@interface NewEditTripViewController : UITableViewController

@property (nonatomic, weak) id <NewEditTripViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSManagedObject* objectToEdit;
@property (nonatomic) bool editModeON;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

