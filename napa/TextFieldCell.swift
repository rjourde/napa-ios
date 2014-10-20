//
//  TextFieldCell.swift
//  napa
//
//  Created by Remy JOURDE on 06/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    @IBOutlet weak var label: UILabel?
    @IBOutlet weak var textField: UITextField?

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
