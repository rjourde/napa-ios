//
//  NewTripViewController.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewTripViewController;

@protocol NewTripViewControllerDelegate <NSObject>
- (void)newTripViewControllerDidCancel:(NewTripViewController *)controller;
- (void)newTripViewControllerDidDone:(NewTripViewController *)controller;
@end

@interface NewTripViewController : UITableViewController

@property (nonatomic, weak) id <NewTripViewControllerDelegate> delegate;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

