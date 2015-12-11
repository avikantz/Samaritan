//
//  DynamicLabel.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "DynamicLabel.h"

#define SPACES @"    "

#define ORIGIN self.bounds.origin
#define SIZE self.bounds.size

@implementation DynamicLabel {
	CAShapeLayer *shapeLayer;
	UIBezierPath *fromPath;
	UIBezierPath *toPath;
	CABasicAnimation *lineAnimation;
	
	BOOL animating;
}

-(void)awakeFromNib {
	if (!self.lineWidth)
		self.lineWidth = 2.f;
	if (!self.wordSpeed)
		self.wordSpeed = 0.6;
	// /*
	if (!shapeLayer) {
		shapeLayer = [[CAShapeLayer alloc] init];
		shapeLayer.bounds = self.bounds;
		shapeLayer.position = CGPointMake(ORIGIN.x + SIZE.width/2, ORIGIN.y + SIZE.height/2 + 4);
		shapeLayer.strokeColor = self.textColor.CGColor;
		shapeLayer.fillColor = self.textColor.CGColor;
		shapeLayer.lineWidth = self.lineWidth;
		[self.layer addSublayer:shapeLayer];
	}
	if (!fromPath) {
		fromPath = [self beizerPathForText:@""];
	}
	if (!toPath) {
		toPath = [self beizerPathForText:self.text];
	}
	if (!lineAnimation) {
		lineAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
		[lineAnimation setDuration:self.wordSpeed * 0.8];
		[lineAnimation setRemovedOnCompletion:NO];
		[lineAnimation setFillMode:kCAFillModeBoth];
		[lineAnimation setTimingFunction: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	}
	animating = NO;
//	[self animateLine];
//	 */
}

/*
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	[super drawRect:rect];
	
	UIBezierPath *bezierPath = [self beizerPathForText:self.text];
	[self.textColor setFill];
	[self.textColor setStroke];
	[bezierPath setLineWidth:self.lineWidth];
	[bezierPath stroke];
	
}
 */


-(UIBezierPath *)beizerPathForText:(NSString *)text {
	CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
	CGFloat prescribedLength = boundingRect.size.width;
	CGFloat offsetx = (SIZE.width - prescribedLength)/2;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(ORIGIN.x + offsetx, ORIGIN.y + SIZE.height - self.lineWidth)];
	[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + SIZE.width - offsetx, ORIGIN.y + SIZE.height - self.lineWidth)];
	return bezierPath;
}

-(void)animateLine {
	[lineAnimation setFromValue:(id)fromPath.CGPath];
	[lineAnimation setToValue:(id)toPath.CGPath];
	[shapeLayer addAnimation:lineAnimation forKey:nil];
	fromPath = toPath;
}

-(void)setTextTokenWise:(NSString *)text andTokens:(NSArray *)tokens atIndex:(NSInteger)index {
	if (index == tokens.count) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.wordSpeed * 1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[super setText:SPACES];
			toPath = [self beizerPathForText:SPACES];
			[self animateLine];
			[self.delegate didFinishTextAnimation];
			animating = NO;
		});
		return;
	}
	toPath = [self beizerPathForText:[tokens objectAtIndex:index]];
	[self animateLine];
	[super setText:[tokens objectAtIndex:index]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.wordSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setTextTokenWise:text andTokens:tokens atIndex:index + 1];
	});
}

-(void)setText:(NSString *)text {
	if (animating) {
		// TODO: enqueue "text"
		return;
	}
	// else dequeue and display
	NSString *mtext = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
//	mtext = [mtext stringByReplacingOccurrencesOfString:@"." withString:@""];
	mtext = [mtext uppercaseString];
	NSArray *tokens = [mtext componentsSeparatedByString:@" "];
	[self setTextTokenWise:mtext andTokens:tokens atIndex:0];
	animating = YES;
	 
//	[super setText:text];
}

-(void)setTextColor:(UIColor *)textColor {
	[super setTextColor:textColor];
	shapeLayer.strokeColor = self.textColor.CGColor;
	shapeLayer.fillColor = self.textColor.CGColor;
}

-(void)setDefaultText:(NSString *)text {
	[super setText:[text uppercaseString]];
	fromPath = [self beizerPathForText:SPACES];
	toPath = [self beizerPathForText:@"COMMANDS"];
//	[self animateLine];
}

@end
