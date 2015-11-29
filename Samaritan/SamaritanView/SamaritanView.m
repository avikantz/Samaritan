//
//  SamaritanView.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "SamaritanView.h"

@implementation SamaritanView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	CGPoint dlOrigin = self.displayLabel.frame.origin;
	CGSize dlSize = self.displayLabel.frame.size;
	
	CGPoint point0 = CGPointMake(dlOrigin.x + 4, dlOrigin.y + dlSize.height + 6);
	CGPoint point1 = CGPointMake(dlOrigin.x + dlSize.width - 8, point0.y);
	CGPoint point12 = CGPointMake(point1.x, point1.y + 2);
	CGPoint point2 = CGPointMake(point1.x, point1.y + 4);
	CGPoint point3 = CGPointMake(point0.x, point2.y);
	CGPoint point30 = CGPointMake(point0.x, point0.y + 2);
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:point0];
	[bezierPath addLineToPoint:point1];
	[bezierPath addArcWithCenter:point12 radius:2 startAngle:0 endAngle:M_PI clockwise:NO];
	[bezierPath moveToPoint:point2];
	[bezierPath addLineToPoint:point3];
	[bezierPath addArcWithCenter:point30 radius:2 startAngle:M_PI endAngle:0 clockwise:YES];
	
}
*/


@end
