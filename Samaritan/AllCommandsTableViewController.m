//
//  AllCommandsTableViewController.m
//  Samaritan
//
//  Created by YASH on 06/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "AllCommandsTableViewController.h"
#import "SamaritanData.h"
#import "Themes.h"
#import "AppDelegate.h"

@interface AllCommandsTableViewController ()
{
    NSMutableArray *commandsArray;
    
    Themes *currentTheme;
}

@end

@implementation AllCommandsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
    NSError *error = nil;
    
    NSArray *fetchedArray = [[AppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    commandsArray = [[NSMutableArray alloc] init];
    commandsArray = [fetchedArray mutableCopy];
    [self.tableView reloadData];
    
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    
    NSFetchRequest *themesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
    [themesRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]];
    NSArray *themes = [[AppDelegate managedObjectContext] executeFetchRequest:themesRequest error:nil];
    currentTheme = [themes firstObject];
    
    // fetched recent theme object, set it to table view and background
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [commandsArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SamaritanData *presentData = [commandsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = presentData.displayString;
    cell.detailTextLabel.text = presentData.tags;
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 40.f;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    return blankView;
    
}

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
