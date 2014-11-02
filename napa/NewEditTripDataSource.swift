//
//  NewEditTripDataSource.swift
//  napa
//
//  Created by Remy JOURDE on 06/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

let titleKey = "title"   // key for obtaining the data source item's title
let dateKey = "date"    // key for obtaining the data source item's date value

let nameSection = 0
let dateSection = 1

// keep track of which rows have date cells
let dateStartRow = 0
let dateEndRow = 1

let nameCellID = "nameCell"     // the cell containing the text field
let dateCellID = "dateCell"     // the cells with the start or end date
let datePickerID = "datePicker" // the cell containing the date picker

protocol NewEditTripDataSourceDelegate {
    func isTripValid(valid: Bool)
    func nameTripDidBeginEditing()
    func nameTripDidEndEditing()
}

class NewEditTripDataSource: NSObject, UITableViewDataSource, UITextFieldDelegate {
    // keep track which indexPath points to the cell with UIDatePicker
    var datePickerIndexPath: NSIndexPath?
    
    var delegate: NewEditTripDataSourceDelegate?
    
    private var tripName = ""
    private var dataArray = [[String:AnyObject]]()
    private var nameTextField: UITextField!
    
    init(tripName: String, startDate: NSDate, endDate: NSDate ) {
        self.tripName = tripName;
        self.dataArray = [[titleKey : "Start Date", dateKey : startDate], [titleKey : "End Date", dateKey : endDate]]
    }
    
    func dismissKeyboard() {
        self.nameTextField.resignFirstResponder()
    }
    
    /*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
    
    @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
    */
    func indexPathHasPicker(indexPath: NSIndexPath) -> Bool {
        return self.datePickerIndexPath?.row == indexPath.row
    }
    
    /*! Determines if the given indexPath points to a cell that contains the start/end dates.
    
    @param indexPath The indexPath to check if it represents start/end date cell.
    */
    func indexPathHasDate(indexPath: NSIndexPath) -> Bool {
        var hasDate = false
    
        if (indexPath.row == dateStartRow)
            || (indexPath.row == dateEndRow)
            || (self.datePickerIndexPath != nil && (indexPath.row == dateEndRow + 1))
        {
            hasDate = true
        }
    
        return hasDate
    }
    
    func itemAtIndex(index: Int) -> AnyObject {
        return self.dataArray[index]
    }
    
    // Mark: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == nameSection {
            return 1
        }
        
        if self.datePickerIndexPath != nil {
            // we have a date picker, so allow for it in the number of rows in this section
            var numRows = self.dataArray.count
            return ++numRows
        }
            
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == nameSection) {
            let textFieldCell: TextFieldCell = tableView.dequeueReusableCellWithIdentifier(nameCellID, forIndexPath: indexPath) as TextFieldCell
            
            self.nameTextField = textFieldCell.textField
            self.nameTextField.text = self.tripName
            self.nameTextField.delegate = self
            self.nameTextField.becomeFirstResponder()
                
            return textFieldCell
        }
        // need to do this only for the date section
        var cellID = ""
        if self.indexPathHasPicker(indexPath) {
            // the indexPath is the one containing the inline date picker
            cellID = datePickerID    // the current/opened date picker cell
        } else if self.indexPathHasDate(indexPath) {
            // the indexPath is one that contains the date information
            cellID = dateCellID      // the start/end date cells
        }
        
        // if we have a date picker open whose cell is above the cell we want to update,
        // then we have one more cell than the model allows
        var modelRow = indexPath.row
        if let datePickerIndexPath = self.datePickerIndexPath {
            if datePickerIndexPath.row < indexPath.row {
                modelRow--
            }
        }
        
        var itemData = [:]
        if !indexPath.isEqual(self.datePickerIndexPath) {
            itemData = self.dataArray[modelRow]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as UITableViewCell
        
        // proceed to configure our cell
        if cellID == dateCellID {
            // we have either start or end date cells, populate their date field
            cell.textLabel.text = itemData[titleKey] as String?
                
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(itemData[dateKey] as NSDate)
            cell.detailTextLabel?.textColor = cell.textLabel.textColor
        }
        
        return cell;
    }
    
    // MARK: - UITextField delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.nameTripDidBeginEditing()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.nameTripDidEndEditing()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString: String) -> Bool {
        let text = textField.text as NSString
        let newText = text.stringByReplacingCharactersInRange(range, withString:replacementString)
        self.delegate?.isTripValid(!newText.isEmpty)
        
        return true
    }
}
