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
#import "TrollViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController () <CLLocationManagerDelegate>

@end

@implementation ViewController
{
	
	NSMutableArray *texts;
	NSMutableArray *commands;
	
	NSManagedObjectContext *managedObjectContext;
	NSFetchRequest *fetchRequest;
	
	Themes *currentTheme;
	
	CLLocation *currentLocation;
    CLLocationManager *locationManager;
    
    CMAltimeter *heightData;
    CMAltitudeData *currentHeight;
	
	NSString *lmPath;
	NSString *dicPath;
    NSString *trollIdentifier;
    NSString *recordedString;
    
    NSNumber *relativeCurrentHeight;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	commands = [NSMutableArray new];
	
	self.textLabel.delegate = self;
	[self.textLabel setDefaultText:@"______"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.textLabel setText:@"What are your commands?"];
	});
	
	/*
	// Test other view controllers here.
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self performSegueWithIdentifier:@"OpenTroll" sender:self];
	});
	 */
	
//	[[Wit sharedInstance] toggleCaptureVoiceIntent:self];
	
	self.openEarsEventsObserver = [[OEEventsObserver alloc] init];
	[self.openEarsEventsObserver setDelegate:self];
	
	[[OEPocketsphinxController sharedInstance] setActive:TRUE error:nil];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	[locationManager requestWhenInUseAuthorization];
	[locationManager startUpdatingLocation];
	currentLocation = [locationManager location];

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
	[wordsModel addObjectsFromArray:@[@"WEATHER", @"MOVIES", @"EPISODE", @"SERIES", @"WHO"]];
	OELanguageModelGenerator *lmGenerator = [[OELanguageModelGenerator alloc] init];
	NSError *err = [lmGenerator generateLanguageModelFromArray:wordsModel withFilesNamed:LANGUAGE_MODEL_FILE_NAME forAcousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"]];
	
	lmPath = nil;
	dicPath = nil;
	
	if(err == nil) {
		lmPath = [lmGenerator pathToSuccessfullyGeneratedLanguageModelWithRequestedName:LANGUAGE_MODEL_FILE_NAME];
		dicPath = [lmGenerator pathToSuccessfullyGeneratedDictionaryWithRequestedName:LANGUAGE_MODEL_FILE_NAME];
		
	}
	else {
		NSLog(@"Error: %@",[err localizedDescription]);
	}
	
	[[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
	
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
	[[OEPocketsphinxController sharedInstance] stopListening];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[OEPocketsphinxController sharedInstance] startListeningWithLanguageModelAtPath:lmPath dictionaryAtPath:dicPath acousticModelAtPath:[OEAcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
	});
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

/*
#pragma mark - Wit delegate

- (void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id) customData error:(NSError*)e {
	if (e) {
		NSLog(@"[Wit] error: %@", [e localizedDescription]);
		return;
	}
	NSDictionary *firstOutcome = [outcomes objectAtIndex:0];
	NSString *intent = [firstOutcome objectForKey:@"intent"];
	
	NSLog(@"WIT OUTPUT: %@", firstOutcome);
	
//	labelView.text = [NSString stringWithFormat:@"intent = %@", intent];
	
//	[self.view addSubview:labelView];
}
 */


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[[OEPocketsphinxController sharedInstance] stopListening];
	if ([segue.identifier isEqualToString:@"SwitchToWeather"])
    {
		UINavigationController *navc = [segue destinationViewController];
		WeatherTableViewController *wtvc = [navc.viewControllers firstObject];
		wtvc.currentLocation = currentLocation;
	}
    if ([segue.identifier isEqualToString:@"OpenTroll"])
    {
        UINavigationController *navc = [segue destinationViewController];
        TrollViewController *tvc = [navc.viewControllers firstObject];
        tvc.identifer = trollIdentifier;
    }
	
}

#pragma mark - OEEventsObserver delegate

- (void) pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
	NSLog(@"\n[pocketsphinx\n\t| hypothesis:'%@'\n\t| score: '%@'\n\t| ID:'%@'.\n\t]", hypothesis, recognitionScore, utteranceID);
	
	// Return if score is less than specified value
	if ([recognitionScore floatValue] < -500000) {
		return;
	}
	
	[[OEPocketsphinxController sharedInstance] resumeRecognition];
    
    //algorithm to return command from recorded audio, after recognition
    
	SamaritanData *matchedData = nil;
	NSArray *extractedTags = [hypothesis componentsSeparatedByString:@" "];
    //NSLog(@"TAGS: %@", extractedTags);
    // defining special cases at the start (random ideas)
    
    if ([self isInternetAvailable])
    {
	
		if ([hypothesis containsString:@"WEATHER"])
        {
			[self performSegueWithIdentifier:@"SwitchToWeather" sender:self];
			return;
		}
        
        if ([hypothesis containsString:@"SERIES"] || [hypothesis containsString:@"MOVIES"])
        {
            [self performSegueWithIdentifier:@"SwitchToListing" sender:self];
            return;
        }
		
    }
	
    // core motion - slowly raise phone for this
    
    else if ([hypothesis containsString:@""] && [self.textLabel.text isEqualToString:@""])
    {
        NSOperationQueue *altitudeQueue;
        [heightData startRelativeAltitudeUpdatesToQueue:(NSOperationQueue *)altitudeQueue withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
            if (currentHeight.relativeAltitude > 0)
            {
                [self.textLabel setText:@"THE FORCE IS STRONG WITH THIS ONE"];
                [heightData stopRelativeAltitudeUpdates];
            }
        }];
    }
    
    else if ([hypothesis isEqualToString:@"WHO"])
    {
        trollIdentifier = @"JOHN CENA";
        [self performSegueWithIdentifier:@"OpenTroll" sender:self];
        return;
    }
	
    else
    {
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
        if (matchedData != nil)
        {
            printf("\nMatched: \"%s\"\n", matchedData.displayString.UTF8String);
            [self.textLabel setText:matchedData.displayString];
            [[OEPocketsphinxController sharedInstance] stopListening];
            [self.redTriangleImageView stopBlinking];
        }
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

#pragma mark - CLLocationManager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	currentLocation = [locations lastObject];
}

- (void)startLocations {
	[locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"failed to get location because of %@", error);
    
}

# pragma mark - Connection Check

- (BOOL) isInternetAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

@end
