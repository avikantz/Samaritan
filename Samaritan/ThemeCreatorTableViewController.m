//
//  ThemeCreatorTableViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 12/11/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ThemeCreatorTableViewController.h"

@interface ThemeCreatorTableViewController ()

@end

@implementation ThemeCreatorTableViewController {
	u_short fgbg;
	Themes *currentTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	fgbg = 0;
	
	currentTheme = [AppDelegate currentTheme];
	[self setTheme:currentTheme];
	
	self.fgColorInfoView.color = [UIColor whiteColor];
	self.bgColorInfoView.color = [UIColor blackColor];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setTheme:(Themes *)theme {
	[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]} forState:UIControlStateNormal];
	self.navigationController.navigationBar.barTintColor = theme.backgroundColor;
	self.navigationController.navigationBar.backgroundColor = theme.backgroundColor;
	self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]};
	[[UINavigationBar appearance] setBackgroundColor:theme.backgroundColor];
	[[UINavigationBar appearance] setBarTintColor:theme.backgroundColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]}];
	[[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
	[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

-(void)viewDidAppear:(BOOL)animated {
	self.previewCell.backgroundColor = self.bgColorInfoView.color;
	self.previewCell.backgroundView.backgroundColor = self.bgColorInfoView.color;
	self.previewCell.themeNameLabel.textColor = self.fgColorInfoView.color;
	self.previewCell.themeNameLabel.text = self.themeNameField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAction:(id)sender {
	if (self.themeNameField.text.length < 4) {
		SHOW_ALERT(@"Theme name should atleast be three characters long.");
		return;
	}
	NSManagedObjectContext *managedObjectContext = [AppDelegate managedObjectContext];
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", self.themeNameField.text]];
	NSArray *predicatedThemes = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	if (predicatedThemes.count > 0) {
		NSString *message = [NSString stringWithFormat:@"A theme with the name '%@' is already present", self.themeNameField.text];
		SHOW_ALERT(message);
		return;
	}
	Themes *theme = [NSEntityDescription insertNewObjectForEntityForName:@"Themes" inManagedObjectContext:managedObjectContext];
	theme.themeName = self.themeNameField.text;
	[theme setForegroundColor:self.fgColorInfoView.color];
	[theme setBackgroundColor:self.bgColorInfoView.color];
	// Add a font module later
	theme.fontName = @"MagdaCleanMono-Regular";
	theme.blinkDuration = 1.6;
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error: %@", error);
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)textFieldTextDidChange:(UITextField *)sender {
	self.previewCell.themeNameLabel.text = self.themeNameField.text;
}


/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}
 */

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

#pragma mark - Text field delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == self.themeNameField) {
		self.previewCell.themeNameLabel.text = textField.text;
	}
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.themeNameField resignFirstResponder];
}

#pragma mark - HRColorPickerViewControllerDelegate

-(void)setSelectedColor:(UIColor *)color {
	if (fgbg == 1)
		self.fgColorInfoView.color = color;
	else if (fgbg == 2)
		self.bgColorInfoView.color = color;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"BackgroundColorPickerSegue"] || [segue.identifier isEqualToString:@"ForegroundColorPickerSegue"]) {
		HRSampleColorPickerViewController *scpvc = [segue destinationViewController];
		scpvc.delegate = self;
		if ([segue.identifier isEqualToString:@"ForegroundColorPickerSegue"]) {
			fgbg = 1;
			scpvc.color = self.fgColorInfoView.color;
		}
		else {
			fgbg = 2;
			scpvc.color = self.bgColorInfoView.color;
		}
	}
}

@end
