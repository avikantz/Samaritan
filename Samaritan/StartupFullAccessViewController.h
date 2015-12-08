//
//  StartupFullAccessViewController.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutlineProgressView.h"
#import "AppDelegate.h"

@interface StartupFullAccessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *totalAccessAchievedView;
@property (weak, nonatomic) IBOutlet UIView *totalAccessFGView;
@property (weak, nonatomic) IBOutlet UILabel *totalAccessLabel;
@property (weak, nonatomic) IBOutlet UILabel *assimilatingDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *governmentFeedsLabel;

@property (weak, nonatomic) IBOutlet UIView *dataAcquisitionView;
@property (weak, nonatomic) IBOutlet UIView *dataAcquisitionFGView;
@property (weak, nonatomic) IBOutlet UILabel *dataAcquisitionLabel;
@property (weak, nonatomic) IBOutlet OutlineProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *execSystemsView;
@property (weak, nonatomic) IBOutlet UIView *execSystemsFGView;
@property (weak, nonatomic) IBOutlet UILabel *execSystemsLabel;
@property (weak, nonatomic) IBOutlet UILabel *execSystemsStatusLabel;


@end
