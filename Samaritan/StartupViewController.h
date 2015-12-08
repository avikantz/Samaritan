//
//  StartupViewController.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutlineProgressView.h"
#import "AppDelegate.h"

@interface StartupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet UILabel *currentResourceLabel;

@property (weak, nonatomic) IBOutlet OutlineProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *connectionEstablishedLabel;

@property (weak, nonatomic) IBOutlet UITextView *randomTextView;



@end
