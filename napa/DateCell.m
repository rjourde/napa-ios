//
//  DateCell.m
//  napa
//
//  Created by Remy JOURDE on 21/06/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "DateCell.h"

@implementation DateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected)
    {
        self.selectedBackgroundView.hidden = YES;
        self.detailTextLabel.textColor = self.tintColor;
    }
    else
    {
        self.detailTextLabel.textColor = self.textLabel.textColor;
    }
    
}

@end
