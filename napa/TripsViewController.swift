//
//  TripsViewController.swift
//  napa
//
//  Created by Remy JOURDE on 01/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit
import CoreData

class TripsViewController: UICollectionViewController, UIGestureRecognizerDelegate, UIActionSheetDelegate, TripsViewControllerDataSourceDelegate, NewEditTripViewControllerDelegate {
    
    enum SegueIdentifier: String {
        case ShowTripSegueIdentifier    = "showTrip"
        case NewTripSegueIdentifier     = "newTrip"
        case EditTripSegueIdentifier    = "editTrip"
    }
    
    enum ButtonIndex: Int {
        case DeleteButtonIndex  = 0
        case EditButtonIndex    = 1
        case CancelButtonIndex  = 2
    }
    
    var managedObjectContext: NSManagedObjectContext?
    var tripsViewControllerDataSource: TripsViewControllerDataSource?
    
    // keep track of the selected collection view cell
    var selectedIndexPath: NSIndexPath?
    
    var currentTrip: Trip?

    override func viewDidLoad() {
        super.viewDidLoad()

        // attach long press gesture to collectionView
        let lpgr = UILongPressGestureRecognizer(target: self, action: "handleLongPress")
        lpgr.minimumPressDuration = 0.5 //seconds
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupFetchedResultsController()
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let point = gestureRecognizer.locationInView(self.collectionView)
    
            self.selectedIndexPath = self.collectionView?.indexPathForItemAtPoint(point)
            if (self.selectedIndexPath != nil)
            {
                let message = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                message.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                message.addAction(UIAlertAction(title: "Delete Trip", style: .Destructive){ (action) in self.deleteTrip() })
                message.addAction(UIAlertAction(title: "Edit Trip", style: .Default){ (action) in self.editTrip() })
                
                presentViewController(message, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupFetchedResultsController() {
        self.tripsViewControllerDataSource = TripsViewControllerDataSource(collectionView: self.collectionView!)
        self.tripsViewControllerDataSource?.fetchedResultsController = Trip.tripsFetchedResultsControllerInManagedObjectContext(self.managedObjectContext!)
        self.tripsViewControllerDataSource?.delegate = self
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func configureCell(cell: AnyObject, object: AnyObject)
    {
        let tripViewCell: TripViewCell = cell as TripViewCell
        let trip: Trip = object as Trip
        tripViewCell.nameLabel?.text = trip.name
    
        let days = trip.endDate - trip.startDate
        if days <= 1 {
            tripViewCell.daysLabel?.text = "1 day"
        } else {
            tripViewCell.daysLabel?.text = "\(days) days"
        }
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd"
        tripViewCell.dateLabel?.text = dateFormatter.stringFromDate(trip.startDate)
    
        dateFormatter.dateFormat = "MMM"
        tripViewCell.monthLabel?.text = dateFormatter.stringFromDate(trip.startDate)
    }

    // MARK: - Navigation
    
    func presentTripViewController(tripViewController: TripViewController) {
        let trip = self.tripsViewControllerDataSource?.selectedItem() as Trip
        tripViewController.setTrip(trip)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        super.prepareForSegue(segue, sender:sender)
        if let segueIdentifier =  SegueIdentifier.fromRaw(segue.identifier) {
            switch segueIdentifier {
            case .ShowTripSegueIdentifier:
                if let currentTrip = self.currentTrip {
                    let tripViewController = segue.destinationViewController as TripViewController
                    tripViewController.setTrip(currentTrip)
                } else {
                    self.presentTripViewController(segue.destinationViewController as TripViewController)
                }
            case .NewTripSegueIdentifier:
                let navigationController = segue.destinationViewController as UINavigationController
                let newTripViewController = navigationController.viewControllers[0] as NewEditTripViewController
                newTripViewController.managedObjectContext = self.managedObjectContext!
                newTripViewController.delegate = self
            case .EditTripSegueIdentifier:
                let navigationController = segue.destinationViewController as UINavigationController
                let editTripViewController = navigationController.viewControllers[0] as NewEditTripViewController
                editTripViewController.managedObjectContext = self.managedObjectContext!
                if let selectedIndexPath = self.selectedIndexPath? {
                    editTripViewController.trip = self.tripsViewControllerDataSource?.itemAtIndexPath(selectedIndexPath) as Trip?
                }
                editTripViewController.delegate = self
            }
        }
    }
    
    // MARK: - NewTripViewController delegate
    
    func newTripViewControllerDidCancel(controller: NewEditTripViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func newTripViewController(controller: NewEditTripViewController, didDoneWith trip: Trip) {
        self.dismissViewControllerAnimated(true, completion:nil)
    
        self.currentTrip = trip
        self.performSegueWithIdentifier(SegueIdentifier.ShowTripSegueIdentifier.toRaw(), sender:self)
    }
    
    // MARK: - UIAlertController action
    
    func editTrip() {
        self.performSegueWithIdentifier(SegueIdentifier.EditTripSegueIdentifier.toRaw(), sender:self)
    }
    
    func deleteTrip() {
        if let selectedIndexPath = self.selectedIndexPath {
            let trip = self.tripsViewControllerDataSource?.itemAtIndexPath(selectedIndexPath) as Trip
            self.managedObjectContext?.undoManager?.setActionName("\(trip.name) trip deletion")
            self.managedObjectContext?.deleteObject(trip)
        }
    }
    
    // MARK: - Undo
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}
