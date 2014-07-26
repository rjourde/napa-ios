//
//  TipsViewControllerDataSource.h
//  napa
//
//  Created by Remy JOURDE on 29/06/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

@protocol TripsViewControllerDataSourceDelegate

- (void)configureCell:(id)cell withObject:(id)object;

@end

@interface TripsViewControllerDataSource : NSObject <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (nonatomic, weak) id<TripsViewControllerDataSourceDelegate> delegate;
@property (nonatomic, copy) NSString* reuseIdentifier;
@property (nonatomic) BOOL paused;

- (id)initWithCollectionView:(UICollectionView*)collectionView;
- (id)selectedItem;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
