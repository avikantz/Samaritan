//
//  AddCommandViewController.h
//  Samaritan
//
//  Created by YASH on 06/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCommandViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *commandTextField;
@property (strong, nonatomic) IBOutlet UITextField *tagTextField;
- (IBAction)doneButton:(UIButton *)sender;

@end