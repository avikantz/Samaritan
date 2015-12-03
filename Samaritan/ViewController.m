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
	
	texts = [NSMutableArray arrayWithObjects:
			 @"What are your commands?",
			 @"Find the machine.",
			 @"Resistance is futile.",
			 @"This was a test.",
			 @"I will protect you now.",
			 @"Not yet.",
			 @"Give yourself up.",
			 @"Welcome to the machine.",
			 @"Deploying countermeasures.",
			 @"System threat imminent.",
			 nil];
	
	[self populateTextLabel];
	
//	samaritanView = [[[NSBundle mainBundle] loadNibNamed:@"SamaritanView" owner:self options:nil] firstObject];
//	[samaritanView setFrame:CGRectMake(0, 0, SWidth - 60, SHeight - 60)];
//	[samaritanView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
//	[self.view addSubview:samaritanView];
	
}

-(void)populateTextLabel {
	[self.textLabel setText:[texts objectAtIndex:arc4random_uniform(10)]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
