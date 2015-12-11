//
//  AddCommandTableViewController.m
//  Samaritan
//
//  Created by YASH on 07/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "AddCommandTableViewController.h"
#import "AppDelegate.h"
#import "Themes.h"
#import "AllCommandsTableViewController.h"

@interface AddCommandTableViewController ()
{
    
    NSString *command;
    NSString *tag;
    
    NSManagedObjectContext *managedObjectContext;
    NSFetchRequest *fetchRequest;
    
    Themes *currentTheme;
    
}

@end

@implementation AddCommandTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
	
	if (self.passedData) {
		self.commandEntry.text = self.passedData.displayString;
		self.tagEntry.text = self.passedData.tags;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentTheme = [AppDelegate currentTheme];
    [self setTheme:currentTheme];
}

-(void)setTheme:(Themes *)theme
{
    self.view.backgroundColor = theme.backgroundColor;
    self.commandEntry.textColor = theme.foregroundColor;
    self.commandEntry.font = [UIFont fontWithName:theme.fontName size:18.f];
    self.commandEntry.backgroundColor = theme.backgroundColor;
    self.tagEntry.textColor = theme.foregroundColor;
    self.tagEntry.font = [UIFont fontWithName:theme.fontName size:18.f];
    self.tagEntry.backgroundColor = theme.backgroundColor;
    self.buttonLabel.textColor = theme.foregroundColor;
    self.buttonLabel.backgroundColor = theme.backgroundColor;
    self.buttonLabel.font = [UIFont fontWithName:theme.fontName size:24.f];
    self.tableView.separatorColor = theme.foregroundColor;
	[[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
	[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

#pragma mark - Table view methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            
            [self.commandEntry becomeFirstResponder];
            
        }
        
    }
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row ==0)
        {
            
            [self.tagEntry becomeFirstResponder];
            
        }
        
    }
    
    if (indexPath.section == tableView.numberOfSections - 1)
    {
        
        [self saveNewCommand];
        [self resignFirstResponder];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) saveNewCommand
{
    
    command = self.commandEntry.text;
    tag = self.tagEntry.text;
	
	if (command.length < 5) {
		SHOW_ALERT(@"Commands must be atleast 5 characters long.");
		return;
	}
	if (tag.length < 3) {
		SHOW_ALERT(@"Tags must be atleast 3 characters long.");
		return;
	}
	
	NSManagedObjectContext *context = [AppDelegate managedObjectContext];
	
	if (self.passedData) {
		self.passedData.displayString = self.commandEntry.text;
		self.passedData.tags = self.tagEntry.text;
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Save error: %@", error);
		}
	}
	else {
		
		NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
		[fetchReq setPredicate:[NSPredicate predicateWithFormat:@"displayString contains[cd] @%", tag]];
		NSError *err = nil;
		
		NSArray *dataArray = [context executeFetchRequest:fetchReq error:&err];
		if (dataArray.count > 0) {
			SHOW_ALERT(@"Command already present!");
			return;
		}
		
        SamaritanData *data = [NSEntityDescription insertNewObjectForEntityForName:@"SamaritanData" inManagedObjectContext:context];
        data.displayString = command;
        data.tags = tag;
        
        if (![context save:&err])
        {
            
            NSLog(@"%@",err);
            
        }
        
    }
	
	[self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 || indexPath.section == 1)
		return 120.f;
    return 40.f;
    
}

#pragma mark - Scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.commandEntry resignFirstResponder];
	[self.tagEntry resignFirstResponder];
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}
*/

@end
