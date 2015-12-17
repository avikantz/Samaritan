//
//  TrollViewController.h
//  Samaritan
//
//  Created by YASH on 17/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TrollViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) NSString *identifer;

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;

@end