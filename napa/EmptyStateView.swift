//
//  EmptyStateView.swift
//  napa
//
//  Created by Remy JOURDE on 09/11/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class EmptyStateView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        let emptyStateLabel = UILabel(frame: CGRectMake(0, 10, frame.width, 300))
        emptyStateLabel.text = "No Trip Digests."
        emptyStateLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(emptyStateLabel)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
