//
//  WeatherTableViewController.h
//  Samaritan
//
//  Created by YASH on 12/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WeatherTableViewController : UITableViewController

@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSString *city;

@end
