//
//  ViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "ViewController.h"
#import "SamaritanData.h"
#import "Themes.h"

@interface ViewController ()

@end

@implementation ViewController {
//	SamaritanView *samaritanView;
	
	NSMutableArray *texts;
	NSMutableArray *commands;
	
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	
	Themes *currentTheme;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	commands = [NSMutableArray new];
	
	self.textLabel.delegate = self;
//	[self.textLabel setText:@"What are your commands?"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
	
}

-(void)viewDidAppear:(BOOL)animated {
	// Load "commands" from Core Data Store
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
	commands = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
	
	NSFetchRequest *themesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	[themesRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]];
	NSArray *themes = [managedObjectContext executeFetchRequest:themesRequest error:nil];
	currentTheme = [themes firstObject];
	
	if (currentTheme) {
		[self setTheme:currentTheme];
	}
}

-(void)populateTextLabel {
	SamaritanData *data = [commands objectAtIndex:arc4random_uniform((int)commands.count)];
	NSString *text = data.displayString;
	[self.textLabel setText:text];
	[self.redTriangleImageView stopBlinking];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([text componentsSeparatedByString:@" "].count * self.textLabel.wordSpeed + 6) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
}

-(void)didFinishTextAnimation {
	[self.redTriangleImageView startBlinking];
}

-(void)setTheme:(Themes *)theme {
	self.view.backgroundColor = theme.backgroundColor;
	self.textLabel.textColor = theme.foregroundColor;
	self.textLabel.font = [UIFont fontWithName:theme.fontName size:28.f];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
