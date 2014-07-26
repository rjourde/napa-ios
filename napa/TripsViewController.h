//
//  MasterViewController.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewTripViewController.h"

@class TripsViewControllerDataSource;

@interface TripsViewController : UICollectionViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
