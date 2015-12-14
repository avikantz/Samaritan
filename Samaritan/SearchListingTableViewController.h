//
//  SearchListingTableViewController.h
//  Samaritan
//
//  Created by YASH on 14/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchListingTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextView *searchQueryTextView;
@property (strong, nonatomic) IBOutlet UITextView *typeOfQueryTextView;
@property (strong, nonatomic) IBOutlet UILabel *searchLabel;

@end
