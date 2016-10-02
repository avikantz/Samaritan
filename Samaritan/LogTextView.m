//
//  LogTextView.m
//  Samaritan
//
//  Created by Avikant Saini on 10/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "LogTextView.h"

@implementation LogTextView

- (void)appendText:(NSString *)text {
	if (self.text.length == 0)
		self.text = text;
	else
		self.text = [NSString stringWithFormat:@"%@\n%@", self.text, text];
}

- (void)removeText {
	self.text = @"";
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
