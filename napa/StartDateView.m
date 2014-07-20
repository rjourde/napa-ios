//
//  StartDateView.m
//  napa
//
//  Created by Remy JOURDE on 20/07/2014.
//  Copyright (c) 2014 Remy Jourde. All rights reserved.
//

#import "StartDateView.h"

@implementation StartDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectangle = CGRectMake(0,0,45,45);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextSetFillColorWithColor(context,
                                     [UIColor colorWithRed:0.0/255.0 green:224.0/255.0 blue:99.0/255.0 alpha:1].CGColor);
    CGContextFillEllipseInRect(context, rectangle);
}

@end
