//
//  ViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
//	SamaritanView *samaritanView;
	
	NSMutableArray *texts;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.textLabel.delegate = self;
	
	texts = [NSMutableArray arrayWithObjects:
			 @"What are your commands?",
			 @"The news slows, people forget. The shares crash, hopes are dashed, people forget. Forget they're hiding.",
			 @"Resistance is futile.",
			 @"This was a test.",
			 @"I will protect you now.",
			 @"Not yet.",
			 @"The sun shines and people forget. The spray flies as the speedboat glides, and people forget. Forget they're hiding",
			 @"Pain. I guess it's a matter of sensation, But somehow, you have a way of avoiding it all. In my mind, I have shot you and stabbed you through your heart, I just didn't understand, The ricochet is the second part.",
			 @"I can't give it up To someone else's touch Because I care too much",
			 @"System threat imminent.",
			 @"You can't hide from the truth, because the truth is all there is.",
			 @"I walk the maze of moments, But everywhere I turn to, Begins a new beginning, But never finds a finish, I walk to the horizon, And there I find another, It all seems so surprising, And then I find that I know.",
			 nil];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
	
}

-(void)populateTextLabel {
	NSString *text = [texts objectAtIndex:arc4random_uniform(12)];
	[self.textLabel setText:text];
	[self.redTriangleImageView stopBlinking];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([text componentsSeparatedByString:@" "].count * self.textLabel.wordSpeed + 4) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
}

-(void)didFinishTextAnimation {
	[self.redTriangleImageView startBlinking];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
