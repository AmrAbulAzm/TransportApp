//
//  TransportOffer.h
//  TransportApp
//
//  Created by Amr AbulAzm on 04/08/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransportOffer : NSObject

@property (nonatomic, strong) NSString *transportOfferID;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *changes;
@property (nonatomic, strong) NSString *arrivalTime;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSDate *arrivalTimeDate;
@property (nonatomic, strong) NSDate *departureTimeDate;


@end
