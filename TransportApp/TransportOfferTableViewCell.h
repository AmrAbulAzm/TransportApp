//
//  TransportOfferTableViewCell.h
//  TransportApp
//
//  Created by Amr AbulAzm on 04/08/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TransportOfferTableViewCellIdentifier = @"TransportOfferTableViewCellIdentifier";

@interface TransportOfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *changesLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end
