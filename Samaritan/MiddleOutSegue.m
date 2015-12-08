//
//  MiddleOutSegue.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "MiddleOutSegue.h"
#import <QuartzCore/QuartzCore.h>

#define degsToRads(degs) degs * M_PI / 180.0f

@implementation MiddleOutSegue

-(void)perform {
	self.window = [[[UIApplication sharedApplication] delegate] window];
//	CGSize viewSize      = [(UIView *)[self.window.subviews objectAtIndex:0] frame].size;
	CGSize viewSize      = self.window.bounds.size;
	CGPoint viewOrigin   = self.window.bounds.origin;
	CGRect leftDoorRect  = CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width / 2.0f, viewSize.height);
	CGRect rightDoorRect = CGRectMake(viewSize.width / 2.0f, viewOrigin.y, viewSize.width / 2.0f, viewSize.height);
	
	self.leftLayer= [CALayer layer];
	self.leftLayer.anchorPoint = CGPointMake(0.0f, 0.5f);
	self.leftLayer.frame  = leftDoorRect;
	CATransform3D leftTransform = self.leftLayer.transform;
	leftTransform.m34 = 1.0f / -420.0f;
	self.leftLayer.transform = leftTransform;
	self.leftLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	
	self.rightLayer = [CALayer layer];
	self.rightLayer.anchorPoint = CGPointMake(1.0f, 0.5f);
	self.rightLayer.frame = rightDoorRect;
	CATransform3D rightTransform = self.rightLayer.transform;
	rightTransform.m34 = 1.0f / -420.0f;
	self.rightLayer.transform = rightTransform;
	self.rightLayer.shadowOffset = CGSizeMake(5.0f, 5.0f);
	
	self.nextViewLayer = [CALayer layer];
	self.nextViewLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
	self.nextViewLayer.frame = CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height);
	CATransform3D nextViewTransform = self.nextViewLayer.transform;
	nextViewTransform.m34 = 1.0f / -420.0f;
	self.nextViewLayer.transform = nextViewTransform;
	
	// Left door image
	self.leftLayer.contents = (id)[MiddleOutSegue clipImageFromLayer:[[self.sourceViewController view] layer] size:leftDoorRect.size offsetX:0.0f];
	
	// Right door image
	self.rightLayer.contents = (id)[MiddleOutSegue clipImageFromLayer:[[self.sourceViewController view] layer] size:rightDoorRect.size offsetX:-leftDoorRect.size.width];
	
	// Next view image
	self.nextViewLayer.contents = (id)[MiddleOutSegue clipImageFromLayer:[[self.destinationViewController view] layer] size:viewSize offsetX:0.0f];
	
	[self.window.layer addSublayer:self.leftLayer];
	[self.window.layer addSublayer:self.rightLayer];
	[self.window.layer addSublayer:self.nextViewLayer];
	
	CAAnimation *leftDoorAnimation = [self middleOutAnimationWithRotationDegree:90.0f];
	leftDoorAnimation.delegate = self;
	[self.leftLayer addAnimation:leftDoorAnimation forKey:@"middleOutAnimationStarted"];
	
	CAAnimation *rightDoorAnimation = [self middleOutAnimationWithRotationDegree:-90.0f];
	rightDoorAnimation.delegate = self;
	[self.rightLayer addAnimation:rightDoorAnimation forKey:@"middleOutAnimationStarted"];
	
	CAAnimation *nextViewAnimation = [self zoomInAnimation];
	nextViewAnimation.delegate = self;
	[self.nextViewLayer addAnimation:nextViewAnimation forKey:@"NextViewAnimationStarted"];
	
	[[self.sourceViewController view] removeFromSuperview];
}
#pragma mark - Core Animation Delegates

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)isFinished {
	
	if (isFinished) {
		
		if ([self.leftLayer animationForKey:@"middleOutAnimationStarted"] == animation ||
			[self.rightLayer animationForKey:@"middleOutAnimationStarted"] == animation) {
			
			[self.leftLayer removeFromSuperlayer];
			[self.rightLayer removeFromSuperlayer];
			
			[self.nextViewLayer removeFromSuperlayer];
		}
		else {
			[self.window setRootViewController:self.destinationViewController];
		}
	}
}

#pragma mark - Image Utilities

+(CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX {
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, offsetX, 0.0f);
	[layer renderInContext:context];
	UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return snapshot.CGImage;
}

#pragma mark - Animations

-(CAAnimation *)zoomInAnimation {
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	
	CABasicAnimation *zoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomInAnimation.fromValue = [NSNumber numberWithFloat:-1000.0f];
	zoomInAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0f];
	
	animationGroup.animations = [NSArray arrayWithObjects:zoomInAnimation, fadeInAnimation, nil];
	animationGroup.duration = 1.5f;
	
	return animationGroup;
}

-(CAAnimation *)middleOutAnimationWithRotationDegree:(CGFloat)degree {
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	
	CABasicAnimation *openAnimimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	openAnimimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	openAnimimation.fromValue = [NSNumber numberWithFloat:degsToRads(0)];
	openAnimimation.toValue = [NSNumber numberWithFloat:degsToRads(degree)];
	
	CABasicAnimation *zoomInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
	zoomInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	zoomInAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	zoomInAnimation.toValue = [NSNumber numberWithFloat:300.0f];
	
	animationGroup.animations = [NSArray arrayWithObjects:openAnimimation, zoomInAnimation, nil];
	animationGroup.duration = 1.5f;
	
	return animationGroup;
}

@end
