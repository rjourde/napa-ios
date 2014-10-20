//
//  NSDateExtensions.swift
//  napa
//
//  Created by Remy JOURDE on 13/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import Foundation

func > (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == NSComparisonResult.OrderedDescending
}
    
func >= (left: NSDate, right: NSDate) -> Bool {
    var comparisonResult = left.compare(right)
    return comparisonResult == NSComparisonResult.OrderedDescending || comparisonResult == NSComparisonResult.OrderedSame
}
    
func < (left: NSDate, right: NSDate) -> Bool {
    return left.compare(right) == NSComparisonResult.OrderedAscending
}
    
func <= (left: NSDate, right: NSDate) -> Bool {
    var comparisonResult = left.compare(right)
    return comparisonResult == NSComparisonResult.OrderedAscending || comparisonResult == NSComparisonResult.OrderedSame
}
    
func - (dateA: NSDate, dateB: NSDate) -> NSTimeInterval {
    return dateA.timeIntervalSinceDate(dateB)
}