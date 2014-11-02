//
//  NewEditTripViewController.swift
//  napa
//
//  Created by Remy JOURDE on 06/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit
import CoreData

protocol NewEditTripViewControllerDelegate {
    func newTripViewControllerDidCancel(controller: NewEditTripViewController)
    func newTripViewController(controller: NewEditTripViewController, didDoneWith trip: Trip)
}

class NewEditTripViewController: UITableViewController, NewEditTripDataSourceDelegate {

    var trip: Trip?
    var delegate: NewEditTripViewControllerDelegate?
    var managedObjectContext: NSManagedObjectContext?
    
    private var tripDataSource: NewEditTripDataSource!
    
    private let datePickerTag = 99     // view tag identifiying the date picker view
    private var pickerCellRowHeight: CGFloat = 0.0
    
    private var tap: UIGestureRecognizer?
    
    func initializeDataSource() {
        if let trip = self.trip {
            self.tripDataSource = NewEditTripDataSource(tripName: trip.name, startDate: trip.startDate, endDate: trip.endDate)
        } else {
            self.tripDataSource = NewEditTripDataSource(tripName: "", startDate: NSDate(), endDate: NSDate())
        }
        
        self.tripDataSource.delegate = self
        self.tableView.dataSource = self.tripDataSource;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.trip == nil {
            self.navigationItem.title = "New Trip"
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
        self.initializeDataSource()
        
        // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
        var pickerViewCellToCheck = self.tableView.dequeueReusableCellWithIdentifier(datePickerID) as UITableViewCell
        self.pickerCellRowHeight = pickerViewCellToCheck.frame.size.height
        
        // if the local changes while in the background, we need to be notified so we can update the date
        // format in the table view cells
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "localeChanged:", name: NSCurrentLocaleDidChangeNotification, object: nil)
        
        self.tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSCurrentLocaleDidChangeNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard()
    {
        self.view.removeGestureRecognizer(self.tap!)
        self.tripDataSource.dismissKeyboard()
    }
    
    // MARK: - Locale
    
    /*! Responds to region format or locale changes.
    */
    func localeChanged(sender: AnyObject) {
        // the user changed the locale (region format) in Settings, so we are notified here to
        // update the date format in the table view cells
        self.tableView.reloadData()
    }
    
    // MARK: - NewEditTripDataSource delegate
    
    func isTripValid(valid: Bool) {
        self.navigationItem.rightBarButtonItem?.enabled = valid
    }
    
    func nameTripDidBeginEditing() {
        self.view.addGestureRecognizer(self.tap!)
    }
    
    func nameTripDidEndEditing() {
        self.view.removeGestureRecognizer(self.tap!)
    }
    
    // MARK: - DatePicker
    
    /*! Determines if the given indexPath has a cell below it with a UIDatePicker.
    
    @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
    */
    func hasPickerForIndexPath(indexPath: NSIndexPath) -> Bool {
        var targetedRow = indexPath.row
        targetedRow++
    
        let checkDatePickerCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: targetedRow, inSection: 0))
        let checkDatePicker = checkDatePickerCell?.viewWithTag(datePickerTag) as UIDatePicker?
    
        return (checkDatePicker != nil)
    }
    
    /*! Updates the UIDatePicker's value to match with the date of the cell above it.
    */
    func updateDatePicker() {
        if let datePickerIndexPath = self.tripDataSource.datePickerIndexPath {
            let associatedDatePickerCell = self.tableView.cellForRowAtIndexPath(datePickerIndexPath)
                
            if let targetedDatePicker = associatedDatePickerCell?.viewWithTag(datePickerTag) as UIDatePicker? {
                // we found a UIDatePicker in this cell, so update it's date value
                let itemData = self.tripDataSource.itemAtIndex(datePickerIndexPath.row - 1) as [String:AnyObject]
                targetedDatePicker.setDate(itemData[dateKey] as NSDate, animated:false)
            }
        }
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tripDataSource.indexPathHasPicker(indexPath) ? self.pickerCellRowHeight : self.tableView.rowHeight
    }
    
    /*! Adds or removes a UIDatePicker cell below the given indexPath.
    
    @param indexPath The indexPath to reveal the UIDatePicker.
    */
    func toggleDatePickerForSelectedIndexPath(indexPath: NSIndexPath) {
        self.tableView.beginUpdates()
    
        let indexPaths = [NSIndexPath(forRow:indexPath.row + 1, inSection: dateSection)]
    
        // check if 'indexPath' has an attached date picker below it
        if self.hasPickerForIndexPath(indexPath) {
            // found a picker below it, so remove it
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        } else {
            // didn't find a picker below it, so we should insert it
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }
    
        self.tableView.endUpdates()
    }
    
    /*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
    
    @param indexPath The indexPath to reveal the UIDatePicker.
    */
    func displayInlineDatePickerForRowAtIndexPath(indexPath: NSIndexPath) {
        // display the date picker inline with the table content
        self.tableView.beginUpdates()
    
        var before = false   // indicates if the date picker is below "indexPath", help us determine which row to reveal
        var sameCellClicked = false
        if let datePickerIndexPath = self.tripDataSource.datePickerIndexPath {
            before = datePickerIndexPath.row < indexPath.row
            sameCellClicked = (datePickerIndexPath.row - 1 == indexPath.row)
            
            // remove any date picker cell if it exists
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let indexPaths = [NSIndexPath(forRow: datePickerIndexPath.row, inSection: dateSection)]
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation:UITableViewRowAnimation.Fade)
            
            self.tripDataSource.datePickerIndexPath = nil
        }
    
        if !sameCellClicked {
            // hide the old date picker and display the new one
            let rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
            let indexPathToReveal = NSIndexPath(forRow: rowToReveal, inSection: dateSection)
    
            self.toggleDatePickerForSelectedIndexPath(indexPathToReveal)
            self.tripDataSource.datePickerIndexPath = NSIndexPath(forRow: indexPathToReveal.row + 1, inSection:dateSection)
        }
    
        self.tableView.endUpdates()
    
        // inform our date picker of the current date to match the current cell
        self.updateDatePicker()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath)?.reuseIdentifier == dateCellID {
            self.displayInlineDatePickerForRowAtIndexPath(indexPath)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        self.delegate?.newTripViewControllerDidCancel(self)
    }
    
    @IBAction func done(sender: AnyObject) {
        let startDate = self.tripDataSource.itemAtIndex(dateStartRow)[dateKey] as NSDate
        let endDate = self.tripDataSource.itemAtIndex(dateEndRow)[dateKey] as NSDate
        
        // Before creating a new trip, check if the dates are valid
        if endDate < startDate {
            let message = UIAlertController(title: "Trip cannot be saved", message: "Start date must be earlier than end date.", preferredStyle: UIAlertControllerStyle.Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            message.addAction(defaultAction)
            
            presentViewController(message, animated: true, completion: nil)
        } else {
            let cellIndexPath = NSIndexPath(forRow: 0, inSection: nameSection)
            let cell = self.tableView.cellForRowAtIndexPath(cellIndexPath) as TextFieldCell
            
            var trip: Trip
            // Create new trip
            if self.trip == nil {
                trip = Trip.insertTripWithName(cell.textField.text, startDate: startDate, endDate: endDate, inManagedObjectContext: self.managedObjectContext!)
            } else {
                // Edit trip
                trip = Trip(name: cell.textField.text, startDate: startDate, endDate: endDate)
            }
                
            self.delegate?.newTripViewController(self, didDoneWith: trip)
        }
    }
    
    /*! User chose to change the date by changing the values inside the UIDatePicker.
    
    @param sender The sender for this action: UIDatePicker.
    */
    @IBAction func dateAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    
        if let datePickerIndexPath = self.tripDataSource.datePickerIndexPath {
            // update the cell's date "above" the date picker cell
            let targetedCellIndexPath = NSIndexPath(forRow: datePickerIndexPath.row - 1, inSection: dateSection)
            
            let cell = self.tableView.cellForRowAtIndexPath(targetedCellIndexPath)
            let targetedDatePicker: UIDatePicker = sender as UIDatePicker
            
            // update our data model
            var itemData = self.tripDataSource.itemAtIndex(targetedCellIndexPath.row) as [String:AnyObject]
            itemData[dateKey] = targetedDatePicker.date
            
            // update the cell's date string
            cell?.detailTextLabel?.text = dateFormatter.stringFromDate(targetedDatePicker.date)
            
            // Start date must be earlier than end date
            let startDate = self.tripDataSource.itemAtIndex(dateStartRow)[dateKey] as NSDate
            let endDate = self.tripDataSource.itemAtIndex(dateEndRow)[dateKey] as NSDate
            
            // update end date cell if start date picker is active
            if datePickerIndexPath.row - 1 == dateStartRow && startDate > endDate {
                // update the end date cell
                let endDateCellIndexPath = NSIndexPath(forRow: datePickerIndexPath.row + 1, inSection: dateSection)
                let endDatecell = self.tableView.cellForRowAtIndexPath(endDateCellIndexPath)
                endDatecell?.detailTextLabel?.text = dateFormatter.stringFromDate(targetedDatePicker.date)
                
                // update date array with new date
                var itemData = self.tripDataSource.itemAtIndex(dateEndRow) as [String:AnyObject]
                itemData[dateKey] = targetedDatePicker.date
            }
            
            // add strike through end date cell if end date picker is active
            if datePickerIndexPath.row - 1 == dateEndRow && endDate < startDate {
                if let text = cell?.detailTextLabel?.text {
                    let attributeString = NSMutableAttributedString(string: text)
                    attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
                    cell?.detailTextLabel?.attributedText = attributeString
                }
            }
        }
    }
}
