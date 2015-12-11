//
//  ThemePickerTableViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ThemePickerTableViewController.h"
#import "SamatitanViewTableViewCell.h"

@interface ThemePickerTableViewController ()

@end

@implementation ThemePickerTableViewController {
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	NSArray *themes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	themes = [NSMutableArray new];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	themes = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	self.tableView.separatorColor = self.selectedTheme.foregroundColor;
	self.tableView.backgroundColor = self.selectedTheme.backgroundColor;
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1)
		return 1;
    return themes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1)
		return 52.f;
	return 160.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addNewThemeCell"];
		cell.textLabel.textColor = self.selectedTheme.foregroundColor;
		cell.backgroundColor = self.selectedTheme.backgroundColor;
		return cell;
	}
	
    SamatitanViewTableViewCell *cell = (SamatitanViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"themePickerCell" forIndexPath:indexPath];
	
	if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"themePickerCell" forIndexPath:indexPath];
	}
	
	Themes *theme = [themes objectAtIndex:indexPath.row];
	
	cell.backgroundColor = theme.backgroundColor;
	cell.backgroundView.backgroundColor = theme.backgroundColor;
	
	cell.themeNameLabel.text = [theme.themeName uppercaseString];
	cell.themeNameLabel.textColor = theme.foregroundColor;
	
	if (theme == self.selectedTheme)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
	
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		self.selectedTheme = [themes objectAtIndex:indexPath.row];
	//	[[NSUserDefaults standardUserDefaults] setValue:self.selectedTheme.themeName forKey:@"selectedTheme"];
		[self.delegate didFinishPickingTheme:self.selectedTheme];
		[self.tableView reloadData];
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[[[UIApplication sharedApplication] keyWindow] setTintColor:self.selectedTheme.foregroundColor];
		[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:self.selectedTheme.backgroundColor];
	}
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
