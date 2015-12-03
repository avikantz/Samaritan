//
//  DynamicLabel.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicLabelDelegate <NSObject>
-(void)didFinishTextAnimation;
@end

IB_DESIGNABLE

@interface DynamicLabel : UILabel

@property IBInspectable CGFloat lineWidth;

@property IBInspectable CGFloat wordSpeed;

@property (weak, nonatomic) id<DynamicLabelDelegate> delegate;

@end
