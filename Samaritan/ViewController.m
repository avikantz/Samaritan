//
//  ViewController.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <Speech/Speech.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

#import "ViewController.h"
#import "SamaritanData.h"
#import "Themes.h"
#import "WeatherTableViewController.h"
#import "Reachability.h"
#import "TrollViewController.h"

@interface ViewController () <CLLocationManagerDelegate, SFSpeechRecognizerDelegate>

@property (nonatomic) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property (nonatomic) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic) AVAudioEngine *audioEngine;

@end

@implementation ViewController {
	
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
	
	UITapGestureRecognizer *tapGesture;

}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	commands = [NSMutableArray new];
	
	self.textLabel.delegate = self;
	
	/*
	// Test other view controllers here.
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self performSegueWithIdentifier:@"OpenTroll" sender:self];
	});
	 */
	
	NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
	
	self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:locale];
	self.speechRecognizer.delegate = self;
	self.recognitionRequest = nil;
	self.recognitionTask = nil;
	self.audioEngine = [[AVAudioEngine alloc] init];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	
	self.textView.text = @"";
	self.textView.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:@"adminMode"];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	currentTheme = [AppDelegate currentTheme];
	[self setTheme:currentTheme];
}

static BOOL appearedOnce = NO;

- (void)viewDidAppear:(BOOL)animated {

	if (!appearedOnce) {
		appearedOnce = YES;
		[self.textLabel setDefaultText:@"____"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.textLabel setText:@"What are your commands?"];
		});
	}

	self.textView.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:@"adminMode"];
	
	// Speech kit
	
	[SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
		switch (status) {
			case SFSpeechRecognizerAuthorizationStatusAuthorized:
				break;
			case SFSpeechRecognizerAuthorizationStatusDenied: {
				SHOW_ALERT(@"Voice recognition denied. Samaritan will find you.");
				break;
			}
			case SFSpeechRecognizerAuthorizationStatusRestricted:
			case SFSpeechRecognizerAuthorizationStatusNotDetermined: {
				SHOW_ALERT(@"Speech recognition restricted on this device.");
				break;
			}
			default:
				break;
		}
	}];
	
	// Location settings
	
	[locationManager requestWhenInUseAuthorization];
	[locationManager startUpdatingLocation];
	currentLocation = [locationManager location];
	
	// Load "commands" from Core Data Store
	
	managedObjectContext = [AppDelegate managedObjectContext];
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
	commands = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
	
	[self.view addGestureRecognizer:tapGesture];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if ([self.audioEngine isRunning]) {
		[self.audioEngine stop];
		[self.recognitionRequest endAudio];
		[self.redTriangleImageView stopBlinking];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark -

- (void)populateTextLabel {
	SamaritanData *data = [commands objectAtIndex:arc4random_uniform((int)commands.count)];
	NSString *text = data.displayString;
	[self.textLabel setText:text];
	[self.redTriangleImageView stopBlinking];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(([text componentsSeparatedByString:@" "].count * self.textLabel.wordSpeed + 6) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self populateTextLabel];
	});
}

- (void)didFinishTextAnimation {
	[self.redTriangleImageView startBlinking];
	[self.textView removeText];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self startRecording];
	});
}

- (void)setTheme:(Themes *)theme {
	self.view.backgroundColor = theme.backgroundColor;
	self.textLabel.textColor = theme.foregroundColor;
	self.textLabel.font = [UIFont fontWithName:theme.fontName size:28.f];
	self.textView.textColor = theme.foregroundColor;
	[[[UIApplication sharedApplication] keyWindow] setTintColor:theme.foregroundColor];
	[[[UIApplication sharedApplication] keyWindow] setBackgroundColor:theme.backgroundColor];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
//	SamaritanData *data = [commands objectAtIndex:arc4random_uniform((int)commands.count)];
//	NSString *text = data.displayString;
//	[self.textLabel setText:text];
//	[self.textLabel setText:@"What are your commands?"];
	
	if ([self.audioEngine isRunning]) {
		[self.audioEngine stop];
		[self.recognitionRequest endAudio];
		[self.redTriangleImageView stopBlinking];
	} else {
		[self startRecording];
		[self.redTriangleImageView startBlinking];
	}
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Speech recording

- (void)startRecording {
	
	if ([self.audioEngine isRunning]) {
		[self.audioEngine stop];
		[self.recognitionRequest endAudio];
		[self.redTriangleImageView stopBlinking];
	}
	
	if (self.recognitionTask != nil) {
		[self.recognitionTask cancel];
		self.recognitionTask = nil;
	}
	
	NSError *error;
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
	if (error) NSLog(@"Error = %@", error);
	[audioSession setMode:AVAudioSessionModeMeasurement error:&error];
	if (error) NSLog(@"Error = %@", error);
	[audioSession setActive:YES error:&error];
	if (error) NSLog(@"Error = %@", error);
	
	self.recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];
	
	AVAudioInputNode *inputNode = [self.audioEngine inputNode];
	if (inputNode == nil) { NSLog(@"Failed to create node."); return; }
	
	if (self.recognitionRequest == nil) { NSLog(@"Fatal error, recog request is nil."); return; }
	
	// Configure request so that results are returned before audio recording is finished
	self.recognitionRequest.shouldReportPartialResults = YES;
	
	// A recognition task represents a speech recognition session.
	// We keep a reference to the task so that it can be cancelled.
	self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
		
		BOOL isFinal = NO;
		NSString *intent;
		
		if (result != nil) {
			intent = result.bestTranscription.formattedString;
			printf("All transcriptions:\n");
			for (SFTranscription *transctiption in result.transcriptions) {
				printf("%s\n", transctiption.formattedString.UTF8String);
			}
			self.textView.text = [NSString stringWithFormat:@">> \"%@\"", intent.uppercaseString];
			isFinal = result.isFinal;
//			NSLog(@"SK INTENT: %@", intent);
		}
		
		if (error != nil || isFinal) {
			
			[self.audioEngine stop];
			[inputNode removeTapOnBus:0];
			
			self.recognitionRequest = nil;
			self.recognitionTask = nil;
			
			[self processSpeechKitHypothesis:intent.uppercaseString];

		}
		
	}];
	
	AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
	[inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
		[self.recognitionRequest appendAudioPCMBuffer:buffer];
	}];
	
	[self.audioEngine prepare];
	
	[self.audioEngine startAndReturnError:&error];
	if (error) { NSLog(@"Failed to start audio engine"); }
	
	NSLog(@"Listening...");
	[self.textView appendText:@"Listening..."];
	
}


- (void)processSpeechKitHypothesis:(NSString *)hypothesis {
	
	NSLog(@"Processing hypothesis: %@", hypothesis);
	
	if (hypothesis.length < 2) {
		NSLog(@"Null hypothesis, returning...");
		[self.textLabel setText:@"Null Hypothesis!"];
		return;
	}
	
	SamaritanData *matchedData = nil;
	NSArray *extractedTags = [hypothesis componentsSeparatedByString:@" "];
	
	// Handle internet and keywords based tasks
	if ([self isInternetAvailable]) {
		if ([hypothesis containsString:@"WEATHER"]) {
			[self performSegueWithIdentifier:@"SwitchToWeather" sender:self];
			return;
		}
		if ([hypothesis containsString:@"SERIES"] || [hypothesis containsString:@"MOVIES"]) {
			[self performSegueWithIdentifier:@"SwitchToListing" sender:self];
			return;
		}
	}

	// Handle general tasks
	
	NSInteger highestNumberOfMatches = 0;
	
	for (SamaritanData *data in commands) {
		
		//NSLog(@"checking %@", data.displayString);
		NSString *upperCaseTags = [data.tags uppercaseString];
		//NSLog(@"tags being checked %@", upperCaseTags);
		BOOL matched = NO;
		// add counter here to find number of tags being matched to
		// return the string with maximum counter
		
		NSInteger numberOfMatchedTags = 0;
		for (NSString *string in extractedTags) {
			
			//NSLog(@"checking tag %@", string);
			if (![upperCaseTags containsString:string])
				matched = NO;
			else {
				numberOfMatchedTags += 1;
				matched = YES;
			}
		}
		//NSLog(@"data %@ with %li tags", data.displayString, (long) numberOfMatchedTags);
		// no need for the boolean flag
		if (numberOfMatchedTags >= highestNumberOfMatches) {
			matchedData = data;
			//NSLog(@"matched data %@ with %li tags", data.displayString, (long) numberOfMatchedTags);
			highestNumberOfMatches = numberOfMatchedTags;
		}
	}
	
	if (matchedData != nil) {
//		printf("\nMatched: \"%s\"\n", matchedData.displayString.UTF8String);
		[self.textView appendText:[NSString stringWithFormat:@"<< \"%@\"", matchedData.displayString.uppercaseString]];
		[self.textLabel setText:matchedData.displayString];
		[self.audioEngine stop];
		[self.recognitionRequest endAudio];
		[self.redTriangleImageView stopBlinking];
	}
	
}

#pragma mark - SFSpeechRecognizerDelegate

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
	NSLog(@"");
	if (available) {
		[self.redTriangleImageView startBlinking];
	} else {
		[self.redTriangleImageView stopBlinking];
	}
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
//	[[OEPocketsphinxController sharedInstance] stopListening];
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

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
	currentLocation = [locations lastObject];
}

- (void)startLocations {
	[locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Failed to get location because of %@", error.localizedDescription);
}

# pragma mark - Connection Check

- (BOOL) isInternetAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
    
}

@end
