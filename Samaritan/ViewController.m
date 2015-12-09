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
// /*              UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
const unsigned char SpeechKitApplicationKey[] = {0x61, 0x26, 0xd5, 0x22, 0xf7, 0x97, 0x88, 0x82, 0x68, 0xcc, 0x0b, 0xf2, 0xd0, 0x6b, 0xfa, 0x2b, 0xee, 0xa7,
    0x21, 0xda, 0xf1, 0xa3, 0x8e, 0x87, 0xf7, 0x2c, 0x03, 0x16, 0xf9, 0x28, 0x11, 0x5b, 0x4e, 0xe7, 0x7d, 0x45,
    0x7e, 0x05, 0xc7, 0xe6, 0xd2, 0xd2, 0xd8, 0xa2, 0x3d, 0xd2, 0xcd, 0x2b, 0x7a, 0xee, 0x05, 0x6b, 0x92, 0x93,
    0xf2, 0x89, 0xbf, 0xf6, 0xa0, 0xb9, 0x1e, 0xb1, 0x14, 0x6c};
//*/
@implementation ViewController
{
//	SamaritanView *samaritanView;
	
	NSMutableArray *texts;
	NSMutableArray *commands;
    
    NSString *recordedString;
	
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	
	Themes *currentTheme;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	commands = [NSMutableArray new];
	
	self.textLabel.delegate = self;
	[self.textLabel setDefaultText:@"______"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
    
    // /*          UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
    self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    [self.appDelegate setupSpeechKitConnection];
    
    self.voiceSearch = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType detection:SKShortEndOfSpeechDetection language:@"en-US" delegate:self];
//     */
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	currentTheme = [AppDelegate currentTheme];
	[self setTheme:currentTheme];
}

-(void)viewDidAppear:(BOOL)animated {
	// Load "commands" from Core Data Store
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
	commands = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
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

// /*          UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
# pragma mark - SKRecognizer Delegate Methods

- (void) recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    
    NSLog(@"Listening...start of recording works");
    
}

- (void) recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    
    NSLog(@"Recorded");
    
}

- (void) recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    
    long numOfResults = [results.results count];
    if (numOfResults > 0)
    {
        
        recordedString = [results firstResult];
        
    }
    
    if (self.voiceSearch)
    {
        
        [self.voiceSearch cancel];
        
    }
    
}

- (void) recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    
    NSLog(@"Error in recording %@", error.localizedDescription);
    
}

@end
