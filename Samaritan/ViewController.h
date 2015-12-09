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
//#import <SpeechKit/SpeechKit.h>

@interface ViewController : UIViewController <DynamicLabelDelegate>

/*UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION (add these to delegate here, SpeechKitDelegate, SKRecognizerDelegate>*/

@property (weak, nonatomic) IBOutlet DynamicLabel *textLabel;

@property (weak, nonatomic) IBOutlet BlinkingImageView *redTriangleImageView;

//@property (strong, nonatomic) SKRecognizer *voiceSearch;

//@property (strong, nonatomic) AppDelegate *appDelegate;

@end