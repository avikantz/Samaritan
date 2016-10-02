//
//  LogTextView.h
//  Samaritan
//
//  Created by Avikant Saini on 10/2/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTextView : UITextView

- (void)appendText:(NSString *)text;
- (void)removeText;

@end
