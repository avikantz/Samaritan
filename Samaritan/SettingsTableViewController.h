//
//  SettingsTableViewController.h
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SamatitanViewTableViewCell.h"

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet SamatitanViewTableViewCell *themePickerCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *showsIntroCell;
@property (weak, nonatomic) IBOutlet UILabel *showsIntroLabel;
@property (weak, nonatomic) IBOutlet UISwitch *showsIntroSwitch;


@end
