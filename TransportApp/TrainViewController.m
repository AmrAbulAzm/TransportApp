//
//  FirstViewController.m
//  TransportApp
//
//  Created by Amr AbulAzm on 04/08/2016.
//  Copyright © 2016 Amr AbulAzm. All rights reserved.
//

#import "TrainViewController.h"
#import "AFNetworking.h"
#import "TransportOffer.h"
#import "TransportOfferTableViewCell.h"

@interface TrainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *offersArray;
@property (nonatomic, assign) BOOL flag;


@end

@implementation TrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.offersArray = [NSMutableArray array];
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.flag = true;
    
    [self fetchData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.topViewController.title = @"Berlin - Munich   Jun 07";
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(changeSortType)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TransportOfferTableViewCell" bundle:nil] forCellReuseIdentifier:TransportOfferTableViewCellIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchData
{
    [self.manager GET:@"https://api.myjson.com/bins/3zmcy" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSArray *offersArray = responseObject;
        
        for (NSDictionary *offer in offersArray) {
            
            NSString *transportOfferID = [offer objectForKey:@"id"];
            NSString *price = [NSString stringWithFormat:@"%@",[offer objectForKey:@"price_in_euros"]];
            NSString *logoURL = [offer objectForKey:@"provider_logo"];
            NSString *changes = [NSString stringWithFormat:@"%@",[offer objectForKey:@"number_of_stops"]];
            NSString *arrivalTime = [offer objectForKey:@"arrival_time"];
            NSString *departureTime = [offer objectForKey:@"departure_time"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSDate *arrivalTimeDate = [dateFormatter dateFromString:arrivalTime];
            NSDate *departureTimeDate = [dateFormatter dateFromString:departureTime];
            
            TransportOffer *offer = [[TransportOffer alloc] init];
            
            offer.transportOfferID = transportOfferID;
            offer.price = price;
            offer.logoURL = logoURL;
            offer.changes = changes;
            offer.arrivalTime = arrivalTime;
            offer.departureTime = departureTime;
            offer.arrivalTimeDate = arrivalTimeDate;
            offer.departureTimeDate = departureTimeDate;
            
            [self.offersArray addObject: offer];
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.offersArray count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TransportOffer *offer = [self.offersArray objectAtIndex:indexPath.row];
    
    TransportOfferTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:TransportOfferTableViewCellIdentifier forIndexPath:indexPath];
    
    NSString *urlString = offer.logoURL;
    urlString = [urlString stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
    
    cell.priceLabel.text = offer.price;
    cell.arrivalTimeLabel.text = offer.arrivalTime;
    cell.departureTimeLabel.text = offer.departureTime;
    cell.durationLabel.text = [self calculateDuration:offer.departureTime secondDate:offer.arrivalTime];
    cell.changesLabel.text = offer.changes;
    
    NSURL *url = [NSURL URLWithString:urlString];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    cell.imageView.image = image;
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Oops"
                                  message:@"Offer details not yet implemented"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)calculateDuration:(NSString *)date1 secondDate:(NSString *)date2
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *tempDate1 = [dateFormatter dateFromString:date1];
    NSDate *tempDate2 = [dateFormatter dateFromString:date2];
    NSTimeInterval interval = [tempDate2 timeIntervalSinceDate:tempDate1];
    int hours = (int)interval / 3600;
    int minutes = (interval - (hours*3600)) / 60;
    NSString *timeDiff = [NSString stringWithFormat:@"%d:%02d", hours, minutes];
    return timeDiff;
}

- (void)changeSortType
{
    if (self.flag)
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"departureTimeDate"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedData = [self.offersArray sortedArrayUsingDescriptors:sortDescriptors];
        self.offersArray = [NSMutableArray arrayWithArray:sortedData];
        self.flag = false;
        [self.tableView reloadData];
    } else {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"arrivalTimeDate"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedData = [self.offersArray sortedArrayUsingDescriptors:sortDescriptors];
        self.offersArray = [NSMutableArray arrayWithArray:sortedData];
        self.flag = true;
        [self.tableView reloadData];
    }
}

@end
