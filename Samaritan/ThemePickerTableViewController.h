//
//  ThemePickerTableViewController.h
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Themes.h"

@protocol ThemePickerDelegate <NSObject>
-(void)didFinishPickingTheme:(Themes *)theme;
@end

@interface ThemePickerTableViewController : UITableViewController

@property (nonatomic, strong) Themes *selectedTheme;

@property (weak, nonatomic) id<ThemePickerDelegate> delegate;

@end
