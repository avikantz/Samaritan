//
//  ThemeCreatorTableViewController.h
//  Samaritan
//
//  Created by Avikant Saini on 12/11/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ColorPicker/HRColorInfoView.h"
#import "HRSampleColorPickerViewController.h"
#import "SamaritanView/SamatitanViewTableViewCell.h"
#import "Themes.h"

@interface ThemeCreatorTableViewController : UITableViewController <HRColorPickerViewControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *themeNameField;
@property (weak, nonatomic) IBOutlet UITableViewCell *themeNameCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *fgColorCell;
@property (weak, nonatomic) IBOutlet HRColorInfoView *fgColorInfoView;
@property (weak, nonatomic) IBOutlet UILabel *fgColorLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *bgColorCell;
@property (weak, nonatomic) IBOutlet HRColorInfoView *bgColorInfoView;
@property (weak, nonatomic) IBOutlet UILabel *bgColorLabel;

@property (weak, nonatomic) IBOutlet SamatitanViewTableViewCell *previewCell;


@end
