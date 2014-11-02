//
//  TripsViewControllerDataSource.swift
//  napa
//
//  Created by Remy JOURDE on 01/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit
import CoreData

protocol TripsViewControllerDataSourceDelegate {
    func configureCell(cell: AnyObject, object: AnyObject)
}

class TripsViewControllerDataSource: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    let tripViewCellIdentifier = "TripCell"
    
    var fetchedResultsController: NSFetchedResultsController? {
        didSet {
            fetchedResultsController?.delegate = self
            fetchedResultsController?.performFetch(nil)
        }
    }
    private weak var collectionView: UICollectionView?
    
    private var sectionChanges = [[NSFetchedResultsChangeType: Int]]()
    private var objectChanges = [[NSFetchedResultsChangeType: [NSIndexPath]]]()
    
    var delegate: TripsViewControllerDataSourceDelegate?
    
    init(collectionView: UICollectionView) {
        super.init()
        
        self.collectionView = collectionView;
        self.collectionView?.dataSource = self;
    }
    
    // Mark: - Collection View
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = self.fetchedResultsController?.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func configureCell(cell:UICollectionViewCell) {
        let highlightedView = UIView(frame: cell.frame)
        highlightedView.backgroundColor = UIColor(red:0.0/255.0, green:224.0/255.0, blue:99.0/255.0, alpha:0.1)
        cell.selectedBackgroundView = highlightedView;
        cell.bringSubviewToFront(cell.selectedBackgroundView)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(tripViewCellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
    
        configureCell(cell)
    
        if let trip = self.fetchedResultsController?.objectAtIndexPath(indexPath) as Trip? {
            self.delegate?.configureCell(cell, object: trip)
        }
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView! {
        var reusableview: UICollectionReusableView?
        
        if (kind == UICollectionElementKindSectionHeader)
        {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:"HeaderView", forIndexPath:indexPath) as TripCollectionHeaderView
            
            let sectionInfo = self.fetchedResultsController?.sections![indexPath.section] as NSFetchedResultsSectionInfo
            
            headerView.title!.text = sectionInfo.name
            
            reusableview = headerView;
        }
        
        return reusableview;
    }
    
    // Mark: - Fetched results controller
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        var change = [NSFetchedResultsChangeType: Int]()
        switch type {
        case .Insert:
            change[type] = sectionIndex
        case .Delete:
            change[type] = sectionIndex
        default: ()
        }
        sectionChanges.append(change)
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath) {
        var change = [NSFetchedResultsChangeType: [NSIndexPath]]()
        switch type {
        case .Insert:
            change[type] = [newIndexPath]
        case .Delete:
            change[type] = [indexPath]
        case .Update:
            change[type] = [indexPath]
        case .Move:
            change[type] = [indexPath, newIndexPath]
    
        }
        objectChanges.append(change)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if sectionChanges.count > 0 {
            self.collectionView?.performBatchUpdates({
                for change in self.sectionChanges
                {
                    for (type, index) in change {
                        switch (type) {
                        case .Insert:
                            self.collectionView?.insertSections(NSIndexSet(index: index))
                        case .Delete:
                            self.collectionView?.deleteSections(NSIndexSet(index: index))
                        case .Update:
                            self.collectionView?.reloadSections(NSIndexSet(index: index))
                        default: ()
                        }
                    }
                }
            }, completion:nil)
        }
    
        if objectChanges.count > 0 && sectionChanges.count == 0 {
            if self.shouldReloadCollectionViewToPreventKnownIssue(self.collectionView) || self.collectionView?.window == nil {
                // This is to prevent a bug in UICollectionView from occurring.
                // The bug presents itself when inserting the first object or deleting the last object in a collection view.
                // http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
                // This code should be removed once the bug has been fixed, it is tracked in OpenRadar
                // http://openradar.appspot.com/12954582
                self.collectionView?.reloadData()
            } else {
                self.collectionView?.performBatchUpdates({
    
                    for change in self.objectChanges {
                        for (type, indexSet) in change {
                            switch type {
                            case .Insert:
                                self.collectionView?.insertItemsAtIndexPaths(indexSet)
                            case .Delete:
                                self.collectionView?.deleteItemsAtIndexPaths(indexSet)
                            case .Update:
                                self.collectionView?.reloadItemsAtIndexPaths(indexSet)
                            case .Move:
                                self.collectionView?.moveItemAtIndexPath(indexSet[0], toIndexPath: indexSet[1])
                            }
                        }
                    }
                }, completion:nil)
            }
        }
    
        self.sectionChanges.removeAll(keepCapacity: true)
        self.objectChanges.removeAll(keepCapacity: true)
    }

    func shouldReloadCollectionViewToPreventKnownIssue(collectionView: UICollectionView?) -> Bool {
        var shouldReload = false
        for change in self.objectChanges {
            for (type, indexSet) in change {
                let indexPath = indexSet[0]
                switch(type) {
                case .Insert:
                    if (self.collectionView?.numberOfItemsInSection(indexPath.section) == 0) {
                        shouldReload = true
                    }
                case .Delete:
                    if (self.collectionView?.numberOfItemsInSection(indexPath.section) == 1) {
                        shouldReload = true
                    }
                default:
                    shouldReload = false
                }
            }
        }
        return shouldReload
    }
    
    func selectedItem() -> AnyObject? {
        if let path = self.collectionView?.indexPathsForSelectedItems()?.last as? NSIndexPath {
            return self.fetchedResultsController?.objectAtIndexPath(path)
        }

        return nil;
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject? {
        return self.fetchedResultsController?.objectAtIndexPath(indexPath)
    }
}
