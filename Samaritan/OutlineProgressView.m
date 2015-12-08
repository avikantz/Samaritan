//
//  OutlineProgressView.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "OutlineProgressView.h"

#define kAnimationDuration 0.5

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height

#define ORIGIN self.bounds.origin

#define CENTER self.bounds.center

@implementation OutlineProgressView {
	CAShapeLayer *shapeLayer;
	UIBezierPath *fromPath;
	UIBezierPath *toPath;
	CABasicAnimation *progressAnimation;
}

-(void)awakeFromNib {
	if (!self.bgColor)
		self.bgColor = [UIColor clearColor];
	if (!self.fgColor)
		self.fgColor = [UIColor blackColor];
	if (!self.cornerRadius)
		self.cornerRadius = 4.f;
	if (!self.borderWidth)
		self.borderWidth = 2.f;
	if (!self.progress)
		self.progress = 0.0f;
	if (!fromPath)
		fromPath = [self beizerPathForProgress:0];
	if (!toPath)
		toPath = [self beizerPathForProgress:0];
	if (!shapeLayer) {
		shapeLayer = [[CAShapeLayer alloc] init];
		shapeLayer.bounds = self.frame;
		shapeLayer.position = self.center;
		shapeLayer.fillColor = self.fgColor.CGColor;
		shapeLayer.strokeColor = self.fgColor.CGColor;
		shapeLayer.lineWidth = self.borderWidth;
		shapeLayer.path = [self beizerPathForProgress:0.6].CGPath;
		[self.layer addSublayer:shapeLayer];
	}
	if (!progressAnimation) {
		progressAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
		[progressAnimation setDuration:kAnimationDuration];
		[progressAnimation setRemovedOnCompletion:NO];
		[progressAnimation setFillMode:kCAFillModeForwards];
		[progressAnimation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	}
	[self animateProgress:self.progress];
}

-(void)setBgColor:(UIColor *)bgColor andFgColor:(UIColor *)fgColor {
	self.bgColor = bgColor;
	self.fgColor = fgColor;
	shapeLayer.fillColor = self.fgColor.CGColor;
	shapeLayer.strokeColor = self.fgColor.CGColor;
}

-(void)animateProgress:(CGFloat)progress {
	self.progress = progress;
	if (self.progress > 1)
		self.progress = 1;
	toPath = [self beizerPathForProgress:progress];
	[progressAnimation setFromValue:(id)fromPath.CGPath];
	[progressAnimation setToValue:(id)toPath.CGPath];
	[shapeLayer addAnimation:progressAnimation forKey:@"fill"];
	fromPath = toPath;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (self.drawsBorder) {
		UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
		[self.fgColor setStroke];
		[borderPath setLineWidth:self.borderWidth];
		[borderPath setLineJoinStyle:kCGLineJoinRound];
		[borderPath stroke];
	}
}

-(UIBezierPath *)beizerPathForProgress:(CGFloat)progress {
	CGFloat insetOffset = self.borderWidth * 2;
	CGRect insetRect = CGRectMake(ORIGIN.x + insetOffset, ORIGIN.y + insetOffset, WIDTH - 2 * insetOffset, HEIGHT - 2 * insetOffset);
	CGRect progressRect = CGRectMake(insetRect.origin.x, insetRect.origin.y, insetRect.size.width * progress, insetRect.size.height);
	UIBezierPath *beizerPath = [UIBezierPath bezierPathWithRoundedRect:progressRect cornerRadius:self.cornerRadius];
	[beizerPath setLineJoinStyle:kCGLineJoinRound];
	[beizerPath setLineWidth:self.borderWidth];
	return beizerPath;
}

@end
