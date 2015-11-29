//
//  BlinkingImageView.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface BlinkingImageView : UIImageView

@property IBInspectable CGFloat blinkDuration;

-(void)stopBlinking;
-(void)startBlinking;

@end
