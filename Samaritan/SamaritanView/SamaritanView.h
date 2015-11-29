//
//  SamaritanView.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlinkingImageView.h"
#import "DynamicLabel.h"

// IB_DESIGNABLE

@interface SamaritanView : UIView

@property (weak, nonatomic) IBOutlet DynamicLabel *displayLabel;

@property (weak, nonatomic) IBOutlet BlinkingImageView *redTriangle;

@end
