//
//  UnderlinedLabel.m
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "UnderlinedLabel.h"

#define SPACES @"    "

#define ORIGIN self.bounds.origin
#define SIZE self.bounds.size

@implementation UnderlinedLabel

 - (void)drawRect:(CGRect)rect {
	// Drawing code

	[super drawRect:rect];

	UIBezierPath *bezierPath = [self beizerPathForText:self.text];
	[self.textColor setFill];
	[self.textColor setStroke];
	[bezierPath setLineWidth:2.0];
	[bezierPath stroke];

}

-(UIBezierPath *)beizerPathForText:(NSString *)text {
	CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
	CGFloat prescribedLength = boundingRect.size.width;
	CGFloat offsetx = (SIZE.width - prescribedLength)/2;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointMake(ORIGIN.x + offsetx, ORIGIN.y + SIZE.height - 2.0)];
	[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + SIZE.width - offsetx, ORIGIN.y + SIZE.height - 2.0)];
	return bezierPath;
}

@end
