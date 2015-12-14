//
//  SearchListingTableViewController.m
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "SearchListingTableViewController.h"
#import "Themes.h"
#import "AppDelegate.h"
#import "ListingTableViewController.h"

@interface SearchListingTableViewController ()
{
    
    Themes *currentTheme;
    
}

@end

@implementation SearchListingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    self.searchQueryTextView.textColor = theme.foregroundColor;
    self.searchQueryTextView.font = [UIFont fontWithName:theme.fontName size:18.f];
    self.searchQueryTextView.backgroundColor = theme.backgroundColor;
    self.typeOfQueryTextView.textColor = theme.foregroundColor;
    self.typeOfQueryTextView.font = [UIFont fontWithName:theme.fontName size:18.f];
    self.typeOfQueryTextView.backgroundColor = theme.backgroundColor;
    self.searchLabel.textColor = theme.foregroundColor;
    self.searchLabel.backgroundColor = theme.backgroundColor;
    self.searchLabel.font = [UIFont fontWithName:theme.fontName size:24.f];
    self.tableView.separatorColor = theme.foregroundColor;
    [[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) performSearch
{
    
    ListingTableViewController *dest = [[ListingTableViewController alloc] init];
    dest.searchFor = self.searchQueryTextView.text;
    dest.typeOf = self.typeOfQueryTextView.text;
    [self performSegueWithIdentifier:@"ShowListing" sender:self];
    
}

# pragma mark - Table view data source

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            
            [self.searchQueryTextView becomeFirstResponder];
            
        }
        
    }
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row ==0)
        {
            
            [self.typeOfQueryTextView becomeFirstResponder];
            
        }
        
    }
    
    if (indexPath.section == tableView.numberOfSections - 1)
    {
        
        [self performSearch];
        [self resignFirstResponder];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

# pragma mark - Scroll view delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.searchQueryTextView resignFirstResponder];
    [self.typeOfQueryTextView resignFirstResponder];
    
}
/*
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
