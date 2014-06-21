//
//  TripViewCell.h
//  napa
//
//  Created by Remy JOURDE on 25/05/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

-(void)setIcon:(UIImage *)icon;

@end
