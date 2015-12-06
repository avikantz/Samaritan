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
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	NSArray *themes;
	
	Themes *selectedTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	themes = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	selectedTheme = [[themes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]] firstObject];
	self.themePickerCell.backgroundColor = selectedTheme.backgroundColor;
	self.themePickerCell.themeNameLabel.text = [selectedTheme.themeName uppercaseString];
	self.themePickerCell.themeNameLabel.textColor = selectedTheme.foregroundColor;
	
	[[NSUserDefaults standardUserDefaults] setValue:selectedTheme.themeName forKey:@"selectedTheme"];

}

-(void)viewDidAppear:(BOOL)animated {
//	NSLog(@"Selected theme: %@.", selectedTheme.themeName);
	self.themePickerCell.backgroundColor = selectedTheme.backgroundColor;
	self.themePickerCell.backgroundView.backgroundColor = selectedTheme.backgroundColor;
	self.themePickerCell.themeNameLabel.text = [selectedTheme.themeName uppercaseString];
	self.themePickerCell.themeNameLabel.textColor = selectedTheme.foregroundColor;
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
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishPickingTheme:(Themes *)theme {
	selectedTheme = theme;
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedTheme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:selectedTheme.fontName size:18.f]} forState:UIControlStateNormal];
	self.navigationController.navigationBar.barTintColor = selectedTheme.backgroundColor;
	self.navigationController.navigationBar.backgroundColor = selectedTheme.backgroundColor;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: selectedTheme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:selectedTheme.fontName size:18.f]};
}

#pragma mark - Table view data source

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"themePickerSegue"]) {
		ThemePickerTableViewController *tptvc = [segue destinationViewController];
		tptvc.themes = themes;
		tptvc.selectedTheme = selectedTheme;
		tptvc.delegate = self;
	}
}


@end
