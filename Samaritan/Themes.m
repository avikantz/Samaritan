//
//  Themes.m
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "Themes.h"

@implementation Themes

// Insert code here to add functionality to your managed object subclass

-(UIColor *)backgroundColor {
	UIColor *bgColor = [UIColor colorWithRed:self.backgroundRed/255.f green:self.backgroundGreen/255.f blue:self.backgroundBlue/255.f alpha:1.f];
	return bgColor;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
	CGFloat bgRed, bgGreen, bgBlue, bgAlpha;
	[backgroundColor getRed:&bgRed green:&bgGreen blue:&bgBlue alpha:&bgAlpha];
	self.backgroundRed = (int)(255 * bgRed);
	self.backgroundGreen = (int)(255 * bgGreen);
	self.backgroundBlue = (int)(255 * bgBlue);
}

-(UIColor *)foregroundColor {
	UIColor *fgColor = [UIColor colorWithRed:self.foregroundRed/255.f green:self.foregroundGreen/255.f blue:self.foregroundBlue/255.f alpha:1.f];
	return fgColor;
}

-(void)setForegroundColor:(UIColor *)foregroundColor {
	CGFloat fgRed, fgGreen, fgBlue, fgAlpha;
	[foregroundColor getRed:&fgRed green:&fgGreen blue:&fgBlue alpha:&fgAlpha];
	self.foregroundRed = (int)(255 * fgRed);
	self.foregroundGreen = (int)(255 * fgGreen);
	self.foregroundBlue = (int)(255 * fgBlue);
}

@end
