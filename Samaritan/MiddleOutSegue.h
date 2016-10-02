//
//  MiddleOutSegue.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiddleOutSegue : UIStoryboardSegue

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) CALayer *leftLayer;
@property (nonatomic, retain) CALayer *rightLayer;
@property (nonatomic, retain) CALayer *nextViewLayer;

- (CAAnimation *)middleOutAnimationWithRotationDegree:(CGFloat)degree;
- (CAAnimation *)zoomInAnimation;

+ (CGImageRef)clipImageFromLayer:(CALayer *)layer size:(CGSize)size offsetX:(CGFloat)offsetX;

@end
