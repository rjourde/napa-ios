//
//  DateCell.swift
//  napa
//
//  Created by Remy JOURDE on 11/10/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.selectedBackgroundView.hidden = true
            self.detailTextLabel?.textColor = self.tintColor
        } else {
            if let textColor = self.textLabel?.textColor {
                self.detailTextLabel?.textColor = textColor
            }
        }

    }

}
