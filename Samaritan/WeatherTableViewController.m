//
//  WeatherTableViewController.m
//  Samaritan
//
//  Created by YASH on 12/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "SSJSONModel.h"
#import "WeatherTableViewCell.h"
#import "Themes.h"
#import "AppDelegate.h"

@interface WeatherTableViewController () <SSJSONModelDelegate>
{
    
    NSDictionary *weatherData;
    NSDictionary *mainKeyData;
    NSDictionary *weatherKeyDataDictionary;
    
    NSArray *weatherKeyData;
    
    SSJSONModel *jsonResponse;
    
    Themes *currentTheme;
    
}
@end

@implementation WeatherTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSURL *weatherUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=f689d3ca074cdcc029cd042eecc7ffdc", _city]];
    jsonResponse = [[SSJSONModel alloc] init];
    [jsonResponse sendRequestWithUrl:weatherUrl];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentTheme = [AppDelegate currentTheme];
    [self setTheme:currentTheme];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) jsonRequestDidCompleteWithResponse:(id)response model:(SSJSONModel *)JSONModel
{
    
    if (JSONModel == jsonResponse)
    {
        
        weatherData = jsonResponse.parsedJsonData;
        mainKeyData = [weatherData objectForKey:@"main"];
        weatherKeyData = [weatherData objectForKey:@"weather"];
        weatherKeyDataDictionary = [weatherKeyData objectAtIndex:0];
        
        NSLog(@"%@", weatherData);
        
    }
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.temperatureOnImage.text = [NSString stringWithFormat:@"%@ C", [mainKeyData objectForKey:@"temp"]];
    cell.temperature.text = [NSString stringWithFormat:@"Temperature : %@ C", [mainKeyData objectForKey:@"temp"]];
    cell.minTemperature.text = [NSString stringWithFormat:@"Minimum : %@ C", [mainKeyData objectForKey:@"temp_min"]];
    cell.maxTemperature.text = [NSString stringWithFormat:@"Maximum : %@ C", [mainKeyData objectForKey:@"temp_max"]];
    cell.typeOfWeather.text = [NSString stringWithFormat:@"%@", [weatherKeyDataDictionary objectForKey:@"description"]];
    
    cell.temperature.backgroundColor = currentTheme.backgroundColor;
    cell.typeOfWeather.backgroundColor = currentTheme.backgroundColor;
    cell.minTemperature.backgroundColor = currentTheme.backgroundColor;
    cell.maxTemperature.backgroundColor = currentTheme.backgroundColor;
    
    cell.temperature.font = [UIFont fontWithName:currentTheme.fontName size:18.f];
    cell.temperatureOnImage.font = [UIFont fontWithName:currentTheme.fontName size:28.f];;
    cell.minTemperature.font = [UIFont fontWithName:currentTheme.fontName size:18.f];;
    cell.maxTemperature.font = [UIFont fontWithName:currentTheme.fontName size:18.f];;
    cell.typeOfWeather.font = [UIFont fontWithName:currentTheme.fontName size:18.f];;
    
    
    // set image view according to type of weather
    
    return  cell;
    
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc] initWithFrame:CGRectZero];
    blankView.backgroundColor = currentTheme.backgroundColor;
    return blankView;
    
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
