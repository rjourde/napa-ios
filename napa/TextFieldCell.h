//
//  TextFieldCell.h
//  napa
//
//  Created by Remy JOURDE on 15/06/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
