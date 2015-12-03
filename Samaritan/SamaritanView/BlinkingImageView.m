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
}

-(void)awakeFromNib {
	if (!self.blinkDuration)
		self.blinkDuration = kDefaultBlinkDuration;
	
	if (!isBlinking)
		isBlinking = YES;
	
	[self blinkSelf];
}

-(void)blinkSelf {
	[UIView animateWithDuration:self.blinkDuration/5 delay:3*self.blinkDuration/5 options:UIViewAnimationOptionCurveEaseIn animations:^{
			self.alpha = 0.0;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:self.blinkDuration/5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
			if (isBlinking)
				self.alpha = 1.0;
		} completion:^(BOOL finished) {
//				if (isBlinking)
			[self blinkSelf];
		}];
	}];
}

-(void)stopBlinking {
	isBlinking = NO;
	[UIView animateWithDuration:self.blinkDuration/5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.alpha = 0.0;
	} completion:nil];
}

-(void)startBlinking {
	isBlinking = YES;
}

-(void)setHidden:(BOOL)hidden {
	[UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		if (hidden)
			self.alpha = 0.0;
		else
			self.alpha = 1.0;
	} completion:^(BOOL finished) {
		[super setHidden:hidden];
	}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
