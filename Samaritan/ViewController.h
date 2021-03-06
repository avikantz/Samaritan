//
//  ViewController.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BlinkingImageView.h"
#import "DynamicLabel.h"
#import "LogTextView.h"

@interface ViewController : UIViewController <DynamicLabelDelegate>

@property (weak, nonatomic) IBOutlet DynamicLabel *textLabel;

@property (weak, nonatomic) IBOutlet BlinkingImageView *redTriangleImageView;

@property (weak, nonatomic) IBOutlet LogTextView *textView;

@end
