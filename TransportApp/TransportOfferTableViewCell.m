//
//  TransportOfferTableViewCell.m
//  TransportApp
//
//  Created by Amr AbulAzm on 04/08/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "TransportOfferTableViewCell.h"

@implementation TransportOfferTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, 0.0f, CGRectGetHeight(rect));
    CGContextAddLineToPoint(context, CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGContextStrokePath(context);
}

@end
