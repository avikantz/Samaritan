//
//  DynamicLabel.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "DynamicLabel.h"

#define SPACES @"      "

#define ORIGIN self.bounds.origin
#define SIZE self.bounds.size

@implementation DynamicLabel

- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	[super drawRect:rect];
	
	if (!self.lineWidth)
		self.lineWidth = 1.f;
	
	CGRect boundingRect = [self.text boundingRectWithSize:SIZE options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
	CGFloat prescribedLength = boundingRect.size.width;
	CGFloat offsetx = (SIZE.width - prescribedLength)/2;
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(ORIGIN.x + offsetx, ORIGIN.y + SIZE.height - self.lineWidth)];
	[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + SIZE.width - offsetx, ORIGIN.y + SIZE.height - self.lineWidth)];
	[[UIColor whiteColor] setFill];
	[[UIColor whiteColor] setStroke];
	[bezierPath setLineWidth:self.lineWidth];
	[bezierPath stroke];
}

-(void)setTextTokenWise:(NSString *)text andTokens:(NSArray *)tokens atIndex:(NSInteger)index {
	if (index == tokens.count) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[super setText:SPACES];
		});
		return;
	}
	[super setText:[[tokens objectAtIndex:index] uppercaseString]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setTextTokenWise:text andTokens:tokens atIndex:index + 1];
	});
}

-(void)setText:(NSString *)text {
	NSArray *tokens = [text componentsSeparatedByString:@" "];
	[self setTextTokenWise:text andTokens:tokens atIndex:0];
}

@end
