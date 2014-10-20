//
//  StartDateView.swift
//  napa
//
//  Created by Remy JOURDE on 11/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class StartDateView: UIView {

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.opaque = false
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        let rectangle = CGRectMake(0,0,45,45)
        let color = UIColor(red: 0.0/255.0, green: 224.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, rectangle)
    }
}
