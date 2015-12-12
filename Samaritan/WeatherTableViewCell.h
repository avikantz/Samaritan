//
//  WeatherTableViewCell.h
//  Samaritan
//
//  Created by YASH on 12/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *typeOfWeatherImage;
@property (strong, nonatomic) IBOutlet UILabel *temperatureOnImage;
@property (strong, nonatomic) IBOutlet UILabel *typeOfWeather;
@property (strong, nonatomic) IBOutlet UILabel *temperature;
@property (strong, nonatomic) IBOutlet UILabel *minTemperature;
@property (strong, nonatomic) IBOutlet UILabel *maxTemperature;

@end
