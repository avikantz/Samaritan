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
#import "WeatherTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"

@interface ViewController () <CLLocationManagerDelegate>

@end
// /*              UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
//const unsigned char SpeechKitApplicationKey[] = {0x61, 0x26, 0xd5, 0x22, 0xf7, 0x97, 0x88, 0x82, 0x68, 0xcc, 0x0b, 0xf2, 0xd0, 0x6b, 0xfa, 0x2b, 0xee, 0xa7,
//    0x21, 0xda, 0xf1, 0xa3, 0x8e, 0x87, 0xf7, 0x2c, 0x03, 0x16, 0xf9, 0x28, 0x11, 0x5b, 0x4e, 0xe7, 0x7d, 0x45,
//    0x7e, 0x05, 0xc7, 0xe6, 0xd2, 0xd2, 0xd8, 0xa2, 0x3d, 0xd2, 0xcd, 0x2b, 0x7a, 0xee, 0x05, 0x6b, 0x92, 0x93,
//    0xf2, 0x89, 0xbf, 0xf6, 0xa0, 0xb9, 0x1e, 0xb1, 0x14, 0x6c};

const unsigned char SpeechKitApplicationKey[] = {0x85, 0x8d, 0xa1, 0x67, 0x8a, 0x78, 0x8f, 0x29, 0x92, 0x7e, 0x27, 0xdf, 0x54, 0x7c, 0x39, 0xd9, 0xcf, 0x91, 0xb5, 0x24, 0x0e, 0x30, 0x08, 0x0f, 0x52, 0x55, 0x10, 0x92, 0x58, 0x2b, 0x27, 0xdd, 0xb8, 0xc9, 0x44, 0x42, 0x41, 0xd4, 0x6b, 0xd3, 0x52, 0x92, 0xb2, 0xa7, 0x0e, 0xeb, 0x80, 0xde, 0x7c, 0x35, 0x02, 0x8a, 0x65, 0x0b, 0x99, 0xb7, 0x60, 0xa9, 0x49, 0xb8, 0xd4, 0x70, 0x95, 0x8c};
//*/
@implementation ViewController
{
//	SamaritanView *samaritanView;
	
	NSMutableArray *texts;
	NSMutableArray *commands;
    
    NSString *recordedString;
    NSString *place;
	
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	
	Themes *currentTheme;
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	commands = [NSMutableArray new];
	
	self.textLabel.delegate = self;
	[self.textLabel setDefaultText:@"______"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		[self populateTextLabel];
		[self.textLabel setText:@"What are your commands?"];
	});
    
    // /*          UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
    self.appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    [self.appDelegate setupSpeechKitConnectionWithDelegate:self];
    self.voiceSearch = [[SKRecognizer alloc] initWithType:SKSearchRecognizerType detection:SKShortEndOfSpeechDetection language:@"en-US" delegate:self];
//     */
	
	self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
	[self.openEarsEventsObserver setDelegate:self];
	
	[[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
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
	
	NSMutableArray *wordsModel = [NSMutableArray new];
	for (SamaritanData *data in commands) {
		for (NSString *string in [data.tags componentsSeparatedByString:@" "]) {
			[wordsModel addObject:[string uppercaseString]];
		}
	}
	OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
	NSError *err = [lmGenerator generateLanguageModelFromArray:wordsModel withFilesNamed:LANGUAGE_MODEL_FILE_NAME forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
	
	NSString *lmPath = nil;
	NSString *dicPath = nil;
	
	if(err == nil) {
		lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:LANGUAGE_MODEL_FILE_NAME];
		dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:LANGUAGE_MODEL_FILE_NAME];
		
	} else {
		NSLog(@"Error: %@",[err localizedDescription]);
	}
	
//	if ([[OEPocketsphinxController sharedInstance] isListening])
//		[[OEPocketsphinxController sharedInstance] stopListening];
	[[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO]; // Change "AcousticModelEnglish" to "AcousticModelSpanish" to perform Spanish recognition instead of English.
	
}

-(void)viewDidDisappear:(BOOL)animated {
	[[OEPocketsphinxController sharedInstance] stopListening];
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
	[[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
	[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    WeatherTableViewController *destination = [[WeatherTableViewController alloc] init];
    destination.city = place;
    
}

#pragma mark - OEEventsObserver delegate

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"\n[pocketsphinx\n\t| hypothesis:'%@'\n\t| score: '%@'\n\t| ID:'%@'.\n\t]", hypothesis, recognitionScore, utteranceID);
	
	// Return if score is less than specified value
	if ([recognitionScore floatValue] < -20000) {
		return;
	}
	
	[[OEPocketsphinxController sharedInstance] resumeRecognition];
    
    //algorithm to return command from recorded audio, after recognition
    
    
    
	SamaritanData *matchedData = nil;
	NSArray *extractedTags = [hypothesis componentsSeparatedByString:@" "];
    //NSLog(@"TAGS: %@", extractedTags);
    
    if ([self isInternetAvailable])
    {
    
        for (NSString *strCheck in extractedTags)
        {
        
            if ([strCheck isEqualToString:@"WEATHER"])
            {
            
                manager = [[CLLocationManager alloc] init];
                geocoder = [[CLGeocoder alloc] init];
                manager.delegate = self;
                manager.desiredAccuracy = kCLLocationAccuracyBest;
                [manager startUpdatingLocation];
                [self performSegueWithIdentifier:@"SwitchToWeather" sender:self];
            
            }
        
        }
        
    }
    
    NSInteger highestNumberOfMatches = 0;
	for (SamaritanData *data in commands)
    {
        //NSLog(@"checking %@", data.displayString);
		NSString *upperCaseTags = [data.tags uppercaseString];
        //NSLog(@"tags being checked %@", upperCaseTags);
		BOOL matched = NO;
        // add counter here to find number of tags being matched to
        // return the string with maximum counter
        
        NSInteger numberOfMatchedTags = 0;
		for (NSString *string in extractedTags)
        {
            //NSLog(@"checking tag %@", string);
			if (![upperCaseTags containsString:string])
				matched = NO;
            else
                numberOfMatchedTags += 1;
		}
        //NSLog(@"data %@ with %li tags", data.displayString, (long) numberOfMatchedTags);
        // no need for the boolean flag
		if (numberOfMatchedTags >= highestNumberOfMatches)
        {
			matchedData = data;
            //NSLog(@"matched data %@ with %li tags", data.displayString, (long) numberOfMatchedTags);
            highestNumberOfMatches = numberOfMatchedTags;
        }
	}
	if (matchedData != nil) {
		printf("\nMatched: \"%s\"\n", matchedData.displayString.UTF8String);
		[self.textLabel setText:matchedData.displayString];
		[self.redTriangleImageView stopBlinking];
	}
}

- (void) pocketsphinxDidStartListening {
	printf("\n[pocketsphinx listening]");
}

- (void) pocketsphinxDidDetectSpeech {
	printf("\n[pocketsphinx speechDetected]");
}

- (void) pocketsphinxDidDetectFinishedSpeech {
	printf("\n[pocketsphinx silence]");
}

- (void) pocketsphinxDidStopListening {
	printf("\n[pocketsphinx stopped]");
	[[OEPocketsphinxController sharedInstance] resumeRecognition];
}

- (void) pocketsphinxDidSuspendRecognition {
	printf("\n[pocketsphinx suspend]");
	[[OEPocketsphinxController sharedInstance] resumeRecognition];
}

- (void) pocketsphinxDidResumeRecognition {
	printf("\n[pocketsphinx resume]");
}

- (void) pocketsphinxDidChangeLanguageModelToFile:(NSString *)newLanguageModelPathAsString andDictionary:(NSString *)newDictionaryPathAsString {
	NSLog(@"Pocketsphinx is now using the following language model: \n%@ and the following dictionary: %@",newLanguageModelPathAsString,newDictionaryPathAsString);
}

- (void) pocketSphinxContinuousSetupDidFailWithReason:(NSString *)reasonForFailure {
	NSLog(@"Listening setup wasn't successful and returned the failure reason: %@", reasonForFailure);
}

- (void) pocketSphinxContinuousTeardownDidFailWithReason:(NSString *)reasonForFailure {
	NSLog(@"Listening teardown wasn't successful and returned the failure reason: %@", reasonForFailure);
}

// /*          UNCOMMENT THIS AFTER SPEECHKIT FRAMEWORK ADDITION
# pragma mark - SKRecognizer Delegate Methods

- (void) recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    
   // NSLog(@"Listening...start of recording works");
    
}

- (void) recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    
    //NSLog(@"Recorded");
    
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
	//NSLog(@"Speech results: %@", results.results);
    
}

- (void) recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    
    //NSLog(@"Error in recording %@", error.localizedDescription);
    
}

# pragma mark - CLLocationManager Delegate Methods

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"failed to get location because of %@", error);
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error == nil && [placemarks count] > 0)
        {
            
            placemark = [placemarks lastObject];
            place = placemark.locality;
            
        }
    }];
    
}

# pragma mark Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

@end
