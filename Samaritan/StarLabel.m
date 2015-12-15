//
//  StarLabel.m
//  Samaritan
//
//  Created by Avikant Saini on 12/15/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "StarLabel.h"

@implementation StarLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	
	//// Shadow Declarations
	NSShadow* shadowInner = [[NSShadow alloc] init];
	[shadowInner setShadowColor: UIColor.blackColor];
	[shadowInner setShadowOffset: CGSizeMake(0.1, -0.1)];
	[shadowInner setShadowBlurRadius: 5];
	NSShadow* shadowOuter = [[NSShadow alloc] init];
	[shadowOuter setShadowColor: UIColor.blackColor];
	[shadowOuter setShadowOffset: CGSizeMake(0.1, -0.1)];
	[shadowOuter setShadowBlurRadius: 10];
	
	//// Star Drawing
	UIBezierPath* starPath = [UIBezierPath bezierPath];
	[starPath moveToPoint: CGPointMake(24, 3)];
	[starPath addLineToPoint: CGPointMake(32.05, 12.92)];
	[starPath addLineToPoint: CGPointMake(43.97, 17.51)];
	[starPath addLineToPoint: CGPointMake(37.02, 28.23)];
	[starPath addLineToPoint: CGPointMake(36.34, 40.99)];
	[starPath addLineToPoint: CGPointMake(24, 37.69)];
	[starPath addLineToPoint: CGPointMake(11.66, 40.99)];
	[starPath addLineToPoint: CGPointMake(10.98, 28.23)];
	[starPath addLineToPoint: CGPointMake(4.03, 17.51)];
	[starPath addLineToPoint: CGPointMake(15.95, 12.92)];
	[starPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOuter.shadowOffset, shadowOuter.shadowBlurRadius, [shadowOuter.shadowColor CGColor]);
	[UIColor.clearColor setFill];
	[starPath fill];
	
	////// Star Inner Shadow
	CGContextSaveGState(context);
	UIRectClip(starPath.bounds);
	CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
	
	CGContextSetAlpha(context, CGColorGetAlpha([shadowInner.shadowColor CGColor]));
	CGContextBeginTransparencyLayer(context, NULL);
	{
		UIColor* opaqueShadow = [shadowInner.shadowColor colorWithAlphaComponent: 1];
		CGContextSetShadowWithColor(context, shadowInner.shadowOffset, shadowInner.shadowBlurRadius, [opaqueShadow CGColor]);
		CGContextSetBlendMode(context, kCGBlendModeSourceOut);
		CGContextBeginTransparencyLayer(context, NULL);
		
		[opaqueShadow setFill];
		[starPath fill];
		
		CGContextEndTransparencyLayer(context);
	}
	CGContextEndTransparencyLayer(context);
	CGContextRestoreGState(context);
	
	CGContextRestoreGState(context);
	
	[UIColor.whiteColor setStroke];
	starPath.lineWidth = 2;
	[starPath stroke];

	[super drawRect:rect];
	
}


@end
