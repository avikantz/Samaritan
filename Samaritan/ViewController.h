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

@interface ViewController : UIViewController <DynamicLabelDelegate, /* SpeechKitDelegate, SKRecognizerDelegate,*/ OEEventsObserverDelegate>

@property (weak, nonatomic) IBOutlet DynamicLabel *textLabel;

@property (weak, nonatomic) IBOutlet BlinkingImageView *redTriangleImageView;

//@property (strong, nonatomic) SKRecognizer *voiceSearch;

@property (strong, nonatomic) AppDelegate *appDelegate;

@property (strong, nonatomic) OEEventsObserver *openEarsEventsObserver;

@end