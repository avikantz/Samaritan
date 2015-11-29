//
//  BlinkingImageView.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "BlinkingImageView.h"

#define kDefaultBlinkDuration 2.0f

@implementation BlinkingImageView {
	BOOL isBlinking;
	NSTimer *timer;
}

-(void)awakeFromNib {
	if (!self.blinkDuration)
		self.blinkDuration = kDefaultBlinkDuration;
	
	if (!isBlinking)
		isBlinking = YES;
	
	timer = [NSTimer timerWithTimeInterval:self.blinkDuration target:self selector:@selector(blinkSelf:) userInfo:nil repeats:YES];
	[timer fire];
}

-(void)blinkSelf:(NSTimer *)aTimer {
	if (isBlinking) {
		[UIView animateWithDuration:self.blinkDuration/5 delay:3*self.blinkDuration/5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.alpha = 0.0;
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:self.blinkDuration/5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
				self.alpha = 1.0;
			} completion:^(BOOL finished) {
				if (isBlinking)
					[self blinkSelf:aTimer];
			}];
		}];
	}
}

-(void)stopBlinking {
	isBlinking = NO;
}

-(void)startBlinking {
	isBlinking = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
