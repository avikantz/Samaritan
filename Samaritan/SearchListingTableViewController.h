//
//  SearchListingTableViewController.h
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListingTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchQueryBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeOfSearchSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableViewCell *typeOfSearchCell;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;

@end
