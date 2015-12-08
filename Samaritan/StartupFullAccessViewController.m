//
//  StartupFullAccessViewController.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "StartupFullAccessViewController.h"
#import "IntelligenceData.h"
#import "Themes.h"

@interface StartupFullAccessViewController ()

@end

@implementation StartupFullAccessViewController {
	NSTimer *loadingTimer;
	NSInteger state;
	
	NSArray *agencies;
	NSInteger currentAgency, currentWeight, totalWeight;
	
	NSArray *execSystems;
	NSInteger currentSystem;
	
	Themes *currentTheme;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
	
	self.execSystemsView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8, 0.8), -240, 0);
	self.dataAcquisitionView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8, 0.8), 240, 0);
	self.execSystemsView.alpha = 0.0;
	self.dataAcquisitionView.alpha = 0.0;
	
	self.totalAccessAchievedView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2, 1.2), 0, -40);
	self.totalAccessAchievedView.alpha = 0.0;
	
	state = 0;
	loadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(animateLoading:) userInfo:nil repeats:YES];
	[loadingTimer fire];
	
	agencies = [IntelligenceData returnArrayFromBundledJSONFile:@"intelligenceData"];
	currentAgency = 0; currentWeight = 0;
	totalWeight = [IntelligenceData totalWeightOfAgencies:agencies];
//	[self animateAgencies];
	
	[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.totalAccessAchievedView.transform = CGAffineTransformIdentity;
		self.totalAccessAchievedView.alpha = 1.0;
	} completion:^(BOOL finished) {
		[self animateAgencies];
	}];
	
	execSystems = [IntelligenceData returnArrayFromBundledJSONFile:@"execSystemsData"];
	currentSystem = 0;
	[self.progressView animateProgress:0.0];
	
	currentTheme = [AppDelegate currentTheme];
	[self setTheme:currentTheme];
}

-(void)animateAgencies {
	if (currentAgency == agencies.count) {
		self.governmentFeedsLabel.text = @"ALL DONE";
		[self startAnimatingSystems];
		return;
	}
	IntelligenceData *ldata = [agencies objectAtIndex:currentAgency];
	self.governmentFeedsLabel.text = ldata.agency;
	currentAgency += 1;
	currentWeight += ldata.weight;
	CGFloat time = (ldata.weight/(totalWeight + 0.f)) * 6.f;
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateAgencies];
	});
}

-(void)animateLoading:(NSTimer *)timer {
	if (state > 2) state = 0;
	else state += 1;
	if (state == 0) {
		self.assimilatingDataLabel.text = @"ASSIMILATING DATA_";
		self.dataAcquisitionLabel.text = @" DATA ACQUISITION_  ";
	}
	else if (state == 1) {
		self.assimilatingDataLabel.text = @"ASSIMILATING DATA_";
		self.dataAcquisitionLabel.text = @" DATA ACQUISITION   ";
	}
	else if (state == 2) {
		self.assimilatingDataLabel.text = @"ASSIMILATING DATA ";
		self.dataAcquisitionLabel.text = @" DATA ACQUISITION_  ";
	}
}

-(void)startAnimatingSystems {
	[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
		self.totalAccessAchievedView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1.2, 1.2), 0, -40);
		self.totalAccessAchievedView.alpha = 0.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.dataAcquisitionView.alpha = 1.0;
			self.dataAcquisitionView.transform = CGAffineTransformIdentity;
			self.execSystemsView.alpha = 1.0;
			self.execSystemsView.transform = CGAffineTransformIdentity;
		} completion:^(BOOL finished) {
			currentWeight = 0;
			totalWeight = [IntelligenceData totalWeightOfAgencies:execSystems];
			[self animateSystems];
		}];
	}];
}

-(void)animateSystems {
	if (currentSystem == execSystems.count) {
		self.execSystemsStatusLabel.text = @"ALL SYSTEMS ACTIVE";
		[UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			self.dataAcquisitionView.alpha = 0.0;
			self.dataAcquisitionView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8, 0.8), -240, 0);
			self.execSystemsView.alpha = 0.0;
			self.execSystemsView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.8, 0.8), 240, 0);
		} completion:^(BOOL finished) {
			[self performSegueWithIdentifier:@"middleOutSegue" sender:self];
		}];
		return;
	}
	IntelligenceData *ldata = [execSystems objectAtIndex:currentSystem];
	self.execSystemsStatusLabel.text = ldata.agency;
	currentSystem += 1;
	currentWeight += ldata.weight;
	CGFloat time = (ldata.weight/(totalWeight + 0.f)) * 6.f;
	[self.progressView animateProgress:(currentWeight/(totalWeight + 0.f))];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateSystems];
	});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTheme:(Themes *)theme {
	self.view.backgroundColor = theme.backgroundColor;
	
	self.totalAccessAchievedView.backgroundColor = theme.foregroundColor;
	self.totalAccessFGView.backgroundColor = theme.backgroundColor;
	self.totalAccessLabel.backgroundColor = theme.foregroundColor;
	self.totalAccessLabel.textColor = theme.backgroundColor;
	self.assimilatingDataLabel.textColor = theme.backgroundColor;
	self.governmentFeedsLabel.textColor = theme.backgroundColor;
	
	self.dataAcquisitionView.backgroundColor = theme.foregroundColor;
	self.dataAcquisitionFGView.backgroundColor = theme.backgroundColor;
	self.dataAcquisitionLabel.backgroundColor = theme.foregroundColor;
	self.dataAcquisitionLabel.textColor = theme.backgroundColor;
	self.progressView.backgroundColor = theme.foregroundColor;
	[self.progressView setBgColor:theme.foregroundColor andFgColor:theme.backgroundColor];
	
	self.execSystemsView.backgroundColor = theme.foregroundColor;
	self.execSystemsFGView.backgroundColor = theme.backgroundColor;
	self.execSystemsLabel.backgroundColor = theme.foregroundColor;
	self.execSystemsLabel.textColor = theme.backgroundColor;
	self.execSystemsStatusLabel.textColor = theme.backgroundColor;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
