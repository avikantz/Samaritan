//
//  TrollViewController.m
//  Samaritan
//
//  Created by YASH on 17/12/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "TrollViewController.h"
#import "Themes.h"
#import "AppDelegate.h"

@interface TrollViewController ()
{
    
    Themes *currentTheme;
    
}

@end

@implementation TrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _identifer;
    
    if ([_identifer isEqualToString:@"JOHN CENA"])
    {
        self.backgroundImage.image = [UIImage imageNamed:@"john cena.jpeg"];
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"John Cena Theme" ofType:@"mp3"];
        NSURL *musicUrl = [NSURL fileURLWithPath:musicPath];
        self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
        self.musicPlayer.numberOfLoops = -1;
        [self.musicPlayer prepareToPlay];
        [self.musicPlayer play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentTheme = [AppDelegate currentTheme];
    [self setTheme:currentTheme];
}

- (void) setTheme:(Themes *)theme
{
    
    self.view.backgroundColor = theme.backgroundColor;
    [[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
    [[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]} forState:UIControlStateNormal];
    self.navigationController.navigationBar.barTintColor = theme.backgroundColor;
    self.navigationController.navigationBar.backgroundColor = theme.backgroundColor;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]};
    [[UINavigationBar appearance] setBackgroundColor:theme.backgroundColor];
    [[UINavigationBar appearance] setBarTintColor:theme.backgroundColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: theme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:theme.fontName size:18.f]}];
    
}

- (IBAction)backAction:(id)sender
{
    [self.musicPlayer stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
