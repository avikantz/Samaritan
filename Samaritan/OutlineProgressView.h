//
//  OutlineProgressView.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface OutlineProgressView : UIView

/// Set progress between 0 and 1
@property (nonatomic, readwrite) IBInspectable CGFloat progress;

@property (strong, nonatomic) IBInspectable UIColor *bgColor;
@property (strong, nonatomic) IBInspectable UIColor *fgColor;

@property IBInspectable BOOL drawsBorder;
@property IBInspectable CGFloat borderWidth;
@property IBInspectable CGFloat cornerRadius;

-(void)setBgColor:(UIColor *)bgColor andFgColor:(UIColor *)fgColor;

-(void)animateProgress:(CGFloat)progress;

@end
