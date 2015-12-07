//
//  AddCommandTableViewController.m
//  Samaritan
//
//  Created by YASH on 07/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "AddCommandTableViewController.h"
#import "AppDelegate.h"
#import "SamaritanData.h"
#import "Themes.h"

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
    
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    
    NSFetchRequest *themesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
    [themesRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]];
    NSArray *themes = [managedObjectContext executeFetchRequest:themesRequest error:nil];
    currentTheme = [themes firstObject];
    
    // fetched recent theme object, set it to text field and background
    
}

#pragma mark - Table view methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        
        if (indexPath.row == 0)
        {
            
            [self.commandTextField becomeFirstResponder];
            
        }
        
    }
    
    if (indexPath.section == 1)
    {
        
        if (indexPath.row ==0)
        {
            
            [self.tagTextField becomeFirstResponder];
            
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
    
    command = self.commandTextField.text;
    tag = self.tagTextField.text;
    
    NSManagedObjectContext *context = [AppDelegate managedObjectContext];
    NSFetchRequest *fetchReq = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
    NSError *err = nil;
    
    NSArray *dataArray = [[AppDelegate managedObjectContext] executeFetchRequest:fetchReq error:&err];
    
    BOOL commandAlreadyAdded = false;
    
    for (int i=0; i<dataArray.count; i++)
    {
        SamaritanData *dataCheck = [dataArray objectAtIndex:i];
        if ([dataCheck.tags isEqualToString:tag])
        {
            commandAlreadyAdded = true;
            break;
        }
    }
    
    if (!commandAlreadyAdded)
    {
        
        SamaritanData *data = [NSEntityDescription insertNewObjectForEntityForName:@"SamaritanData" inManagedObjectContext:context];
        data.displayString = command;
        data.tags = tag;
        
        NSLog(@"Favourites %@ %@", data.displayString, data.tags);
        
        if (![context save:&err])
        {
            
            NSLog(@"%@",err);
            
        }
        
    }
    
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
