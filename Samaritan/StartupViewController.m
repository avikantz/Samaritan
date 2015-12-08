//
//  StartupViewController.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "StartupViewController.h"
#import "LoadingData.h"
#import "Themes.h"

@interface StartupViewController ()

@end

@implementation StartupViewController {
	NSTimer *loadingTimer;
	NSInteger state;
	
	NSArray *commands;
	NSInteger currentCommand, currentWeight, totalWeight;
	
	Themes *currentTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.connectionEstablishedLabel.alpha = 0.0;
	
	state = 0;
	loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(animateLoading:) userInfo:nil repeats:YES];
	[loadingTimer fire];
	
	commands = [LoadingData returnArrayFromBundledJSONFile:@"loadingData"];
	currentCommand = 0; currentWeight = 0;
	totalWeight = [LoadingData totalWeightOfCommands:commands];
	[self animateCommand];
	
	currentTheme = [AppDelegate currentTheme];
	[self setTheme:currentTheme];
}

-(void)animateCommand {
	if (currentCommand == commands.count) {
		[self.progressView animateProgress:1];
		[self animateConnectionEstablished];
		[loadingTimer invalidate];
		return;
	}
	LoadingData *ldata = [commands objectAtIndex:currentCommand];
	self.currentResourceLabel.text = ldata.command;
	currentCommand += 1;
	currentWeight += ldata.weight;
	[self.progressView animateProgress:currentWeight/(totalWeight + 0.f)];
//	CGFloat time = (ldata.isSingle)?(ldata.weight/240):(ldata.weight/totalWeight);
	CGFloat time = ldata.weight/(totalWeight + 0.f);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateCommand];
	});
}

-(void)animateLoading:(NSTimer *)timer {
	if (state > 5) state = 0;
	else state += 1;
	if (state == 0) self.loadingLabel.text = @"LOADING.  ";
	else if (state == 1) self.loadingLabel.text = @"LOADING.. ";
	else if (state == 2) self.loadingLabel.text = @"LOADING...";
	else if (state == 3) self.loadingLabel.text = @"LOADING ..";
	else if (state == 4) self.loadingLabel.text = @"LOADING  .";
	else if (state == 5) self.loadingLabel.text = @"LOADING   ";
}

-(void)animateConnectionEstablished {
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.loadingLabel.alpha = 0.0;
		self.currentResourceLabel.alpha = 0.0;
		self.progressView.alpha = 0.0;
		self.randomTextView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.07 initialSpringVelocity:1.0 options:  UIViewAnimationOptionAutoreverse animations:^{
			self.connectionEstablishedLabel.alpha = 1.0;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
				self.connectionEstablishedLabel.alpha = 1.0;
			} completion:^(BOOL finished) {
				[self performSegueWithIdentifier:@"startupFullSegue" sender:self];
			}];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheme:(Themes *)theme {
	self.view.backgroundColor = theme.backgroundColor;
	
	self.loadingLabel.backgroundColor = theme.foregroundColor;
	self.loadingLabel.textColor = theme.backgroundColor;
	self.currentResourceLabel.textColor = theme.foregroundColor;
	
	self.progressView.backgroundColor = theme.backgroundColor;
	[self.progressView setBgColor:theme.backgroundColor andFgColor:theme.foregroundColor];
	
	self.connectionEstablishedLabel.backgroundColor = theme.foregroundColor;
	self.connectionEstablishedLabel.textColor = theme.backgroundColor;
	self.randomTextView.textColor = theme.foregroundColor;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	
}


@end
