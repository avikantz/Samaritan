//
//  SettingsTableViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ThemePickerTableViewController.h"

@interface SettingsTableViewController () <ThemePickerDelegate>

@end

@implementation SettingsTableViewController {
	Themes *selectedTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	selectedTheme = [AppDelegate currentTheme];
	[self setTheme:selectedTheme];
	[[NSUserDefaults standardUserDefaults] setValue:selectedTheme.themeName forKey:@"selectedTheme"];
	
	self.showsIntroSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"showsIntro"];
	self.adminModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"adminMode"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneAction:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject:selectedTheme.themeName forKey:@"selectedTheme"];
	[[NSUserDefaults standardUserDefaults] setBool:self.adminModeSwitch.on forKey:@"adminMode"];
	[[NSUserDefaults standardUserDefaults] setBool:self.showsIntroSwitch.on forKey:@"showsIntro"];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFinishPickingTheme:(Themes *)theme {
	selectedTheme = theme;
	[self setTheme:theme];
}

- (void)setTheme:(Themes *)theme {
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]} forState:UIControlStateNormal];
	self.navigationController.navigationBar.barTintColor = theme.backgroundColor;
	self.navigationController.navigationBar.backgroundColor = theme.backgroundColor;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]};
	[[UINavigationBar appearance] setBackgroundColor:theme.backgroundColor];
	[[UINavigationBar appearance] setBarTintColor:theme.backgroundColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]}];
	self.tableView.backgroundColor = theme.backgroundColor;
	self.tableView.backgroundView.backgroundColor = theme.backgroundColor;
	self.tableView.separatorColor = theme.foregroundColor;
	self.themePickerCell.backgroundColor = theme.backgroundColor;
	self.themePickerCell.backgroundView.backgroundColor = theme.backgroundColor;
	self.themePickerCell.themeNameLabel.text = [theme.themeName uppercaseString];
	self.themePickerCell.themeNameLabel.textColor = theme.foregroundColor;
	self.showsIntroCell.backgroundColor = theme.backgroundColor;
	self.showsIntroCell.backgroundView.backgroundColor = theme.backgroundColor;
	self.showsIntroLabel.textColor = theme.foregroundColor;
	self.showsIntroSwitch.onTintColor = theme.foregroundColor;
	self.showsIntroSwitch.tintColor = theme.foregroundColor;
	self.showsIntroSwitch.thumbTintColor = theme.backgroundColor;
	self.adminModeSwitch.onTintColor = theme.foregroundColor;
	self.adminModeSwitch.tintColor = theme.foregroundColor;
	self.adminModeSwitch.thumbTintColor = theme.backgroundColor;
	[[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
	[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Switches

- (IBAction)showsIntroSwitchValueChanged:(UISwitch *)sender {
//	[[NSUserDefaults standardUserDefaults] setBool:self.showsIntroSwitch.on forKey:@"showsIntro"];
}

- (IBAction)adminModeSwitchValueChanged:(UISwitch *)sender {
//	[[NSUserDefaults standardUserDefaults] setBool:self.adminModeSwitch.on forKey:@"adminMode"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"themePickerSegue"]) {
		ThemePickerTableViewController *tptvc = [segue destinationViewController];
		tptvc.selectedTheme = selectedTheme;
		tptvc.delegate = self;
	}
}


@end
