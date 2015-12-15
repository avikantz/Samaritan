//
//  UnderlinedLabel.h
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface UnderlinedLabel : UILabel

@property IBInspectable BOOL drawsUnderline;
@property IBInspectable CGFloat lineWidth;

@end
