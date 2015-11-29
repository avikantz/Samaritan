//
//  DynamicLabel.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "DynamicLabel.h"

#define ORIGIN self.frame.origin
#define SIZE self.frame.size

@implementation DynamicLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//	
//	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//	[bezierPath moveToPoint:CGPointMake(ORIGIN.x + 2, ORIGIN.y + SIZE.height - 1)];
//	[bezierPath addLineToPoint:CGPointMake(ORIGIN.x + SIZE.width - 4, ORIGIN.y + SIZE.height - 1)];
//	[[UIColor whiteColor] setStroke];
//	[bezierPath setLineWidth:0.5];
//	[bezierPath stroke];
//}


@end
