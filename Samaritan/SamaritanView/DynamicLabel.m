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
	
}

-(void)awakeFromNib {
	if (!self.lineWidth)
		self.lineWidth = 2.f;
	if (!self.wordSpeed)
		self.wordSpeed = 0.6;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	[super drawRect:rect];
	
	CGRect boundingRect = [self.text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
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
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.wordSpeed * 1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[super setText:SPACES];
			[self.delegate didFinishTextAnimation];
		});
		return;
	}
	[super setText:[tokens objectAtIndex:index]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.wordSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setTextTokenWise:text andTokens:tokens atIndex:index + 1];
	});
}

-(void)setText:(NSString *)text {
	NSString *mtext = [text stringByReplacingOccurrencesOfString:@"," withString:@""];
//	mtext = [mtext stringByReplacingOccurrencesOfString:@"." withString:@""];
	mtext = [mtext uppercaseString];
	NSArray *tokens = [mtext componentsSeparatedByString:@" "];
	[self setTextTokenWise:mtext andTokens:tokens atIndex:0];
}

@end
