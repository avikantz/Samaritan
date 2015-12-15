//
//  DoubleUnderlinedLabel.m
//
//  Created by Avikant Saini on 12/14/15.
//  Copyright © 2015 avikantz. All rights reserved.
//

#import "DoubleUnderlinedLabel.h"

#define WIDTH self.bounds.size.width
#define HEIGHT self.bounds.size.height

@implementation DoubleUnderlinedLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	[super drawRect:rect];
	
	if (self.text.length > 1) {
	
		if (!self.lineWidth)
			self.lineWidth = 2.f;
		if (!self.offset)
			self.offset = WIDTH * 1 / 2;
		if (!self.lineColor)
			self.lineColor = [UIColor whiteColor];
		
		CGPoint topStartPoint = CGPointMake(self.offset/2, self.lineWidth/2);
		CGPoint topEndPoint = CGPointMake(WIDTH - self.offset/2, topStartPoint.y);
		CGPoint bottomStartPoint = CGPointMake(self.offset/2, HEIGHT - self.lineWidth/2);
		CGPoint bottomEndPoint = CGPointMake(WIDTH - self.offset/2, bottomStartPoint.y);
		
		UIBezierPath *beizerPath = [UIBezierPath bezierPath];
		[beizerPath moveToPoint:topStartPoint];
		[beizerPath addLineToPoint:topEndPoint];
		[beizerPath moveToPoint:bottomStartPoint];
		[beizerPath addLineToPoint:bottomEndPoint];
		[beizerPath setLineWidth:self.lineWidth];
		[self.lineColor setStroke];
		[beizerPath stroke];
		
	}
	
}

-(void)setText:(NSString *)text {
	[super setText:[text uppercaseString]];
}


@end
