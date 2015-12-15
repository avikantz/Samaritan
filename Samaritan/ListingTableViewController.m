//
//  ListingTableViewController.m
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ListingTableViewController.h"
#import "ListingTableViewCell.h"
#import "AppDelegate.h"
#import "Themes.h"

@interface ListingTableViewController ()
{
    
    Themes *currentTheme;
    
    NSDictionary *searchData;
    NSDictionary *listingData;
    NSDictionary *dataToBeDisplayed;
    
    NSArray *searchKeyArray;
    
    NSString *imdbId;
    
}

@end

@implementation ListingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *searchQuery = @"doctor+who";
    NSString *typeToQuery = @"series";
    
    NSString *listingUrlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@&type=%@&r=json", searchQuery, typeToQuery];      // split _searchFor at " " and replace with +
    NSURL *listingUrl = [NSURL URLWithString:listingUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:listingUrl];
        NSError *error;
        
        if (data != nil)
        {
            
            searchData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", searchData);
            
        }
    });
    
    searchKeyArray = [searchData objectForKey:@"Search"];
    listingData = [searchKeyArray objectAtIndex:0];
    imdbId = [listingData objectForKey:@"imdbID"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@&y=&plot=short&r=json", imdbId]]];
        NSError *error;
        
        if (data != nil)
        {
            dataToBeDisplayed = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"%@", dataToBeDisplayed);
        }
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentTheme = [AppDelegate currentTheme];
    [self setTheme:currentTheme];
    [self.tableView reloadData];
}

- (void) setTheme:(Themes *)theme
{
    
    self.view.backgroundColor = theme.backgroundColor;
    [[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]} forState:UIControlStateNormal];
    self.navigationController.navigationBar.barTintColor = theme.backgroundColor;
    self.navigationController.navigationBar.backgroundColor = theme.backgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]};
    [[UINavigationBar appearance] setBackgroundColor:theme.backgroundColor];
    [[UINavigationBar appearance] setBarTintColor:theme.backgroundColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]}];
    
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 490;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"listingCell";
    ListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ListingCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    if (cell == nil)
    {
        cell = [[ListingTableViewCell alloc] init];
    }
    cell.nameLabel.text = @"Doctor Who";
    cell.description.text = [dataToBeDisplayed objectForKey:@"Plot"];
    cell.imdbRatingLabel.text = [dataToBeDisplayed objectForKey:@"imdbRating"];
    cell.metascoreLabel.text = [dataToBeDisplayed objectForKey:@"Metascore"];
    cell.castLabel.text = [dataToBeDisplayed objectForKey:@"Actors"];
    cell.genreLabel.text = [dataToBeDisplayed objectForKey:@"Genre"];
    // image is at key Poster
    
    return cell;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    blankView.backgroundColor = currentTheme.backgroundColor;
    return blankView;
    
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
