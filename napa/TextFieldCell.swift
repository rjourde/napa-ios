//
//  TextFieldCell.swift
//  napa
//
//  Created by Remy JOURDE on 06/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    var textField = UITextField()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textField.font = UIFont.systemFontOfSize(16.0)
        self.textField.placeholder = "Name"
        
        contentView.addSubview(textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textField.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + 15.0,
            CGRectGetMinY(self.contentView.frame),
            CGRectGetWidth(self.contentView.frame) - 15.0,
            CGRectGetHeight(self.contentView.frame))
    }
    
}
