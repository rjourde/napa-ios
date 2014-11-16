//
//  OverlayView.swift
//  napa
//
//  Created by Remy JOURDE on 16/11/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class OverlayView: UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect)
    {
        let circleWidth = frame.width - 20.0
        let circleheight = frame.width - 20.0
        let circleX = (frame.width - circleWidth) / 2.0
        let circleY = (frame.height - circleheight) / 2.0
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, UIColor.blueColor().CGColor)
        let ellipse = CGRectMake(circleX, circleY, circleWidth, circleheight)
        CGContextAddRect(context, ellipse)
        CGContextStrokeEllipseInRect(context, ellipse)
        
        CGContextSetFillColorWithColor(context, UIColor.blueColor().colorWithAlphaComponent(0.1).CGColor)
        CGContextAddRect(context, rect)
        CGContextFillRect(context, rect)
        let rectPath = CGPathCreateMutable()
        CGPathAddRect(rectPath, nil, rect)
        CGContextAddPath(context, rectPath)
        
        let circle = CGRectMake(circleX, circleY, circleWidth, circleheight)
        let cutoutPath = CGPathCreateMutable()
        CGPathAddEllipseInRect(cutoutPath, nil, circle)
        CGContextAddPath(context, cutoutPath)
        
        CGContextEOFillPath(context);
    }
}
