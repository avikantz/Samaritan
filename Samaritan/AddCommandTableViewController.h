//
//  AddCommandTableViewController.h
//  Samaritan
//
//  Created by YASH on 07/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SamaritanData.h"

@interface AddCommandTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextView *commandEntry;
@property (strong, nonatomic) IBOutlet UITextView *tagEntry;
@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;

@property (strong, nonatomic) SamaritanData *passedData;


@end