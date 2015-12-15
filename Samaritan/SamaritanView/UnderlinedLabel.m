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
	 
	 if (!self.lineWidth)
		 self.lineWidth = 2.f;

	if (self.drawsUnderline) {
		UIBezierPath *bezierPath = [self beizerPathForText:[self.text uppercaseString] andAlignment:self.textAlignment];
		[self.textColor setFill];
		[self.textColor setStroke];
		[bezierPath setLineWidth:self.lineWidth];
		[bezierPath stroke];
	}

}

-(void)setText:(NSString *)text {
	[super setText:[text uppercaseString]];
}

-(UIBezierPath *)beizerPathForText:(NSString *)text andAlignment:(NSTextAlignment)alignment {
	CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil];
	CGFloat prescribedLength = boundingRect.size.width;
	CGFloat offsetx = (SIZE.width - prescribedLength)/2;
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	if (alignment == NSTextAlignmentLeft || alignment == NSTextAlignmentNatural || alignment == NSTextAlignmentJustified) {
		[bezierPath moveToPoint:CGPointMake(ORIGIN.x, ORIGIN.y + SIZE.height - 2.0)];
		[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + prescribedLength, ORIGIN.y + SIZE.height - 2.0)];
	}
	else if (alignment == NSTextAlignmentRight) {
		[bezierPath moveToPoint:CGPointMake(ORIGIN.x + SIZE.width - prescribedLength, ORIGIN.y + SIZE.height - 2.0)];
		[bezierPath addLineToPoint:CGPointMake(SIZE.width, ORIGIN.y + SIZE.height - 2.0)];
	}
	else {
		[bezierPath moveToPoint:CGPointMake(ORIGIN.x + offsetx, ORIGIN.y + SIZE.height - 2.0)];
		[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + SIZE.width - offsetx, ORIGIN.y + SIZE.height - 2.0)];
	}
	return bezierPath;
}

@end
