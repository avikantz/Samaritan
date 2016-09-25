//
//  AppDelegate.m
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "AppDelegate.h"
#import "SamaritanData.h"
#import "Themes.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SamaritanData"];
	NSError *error;
	NSArray *commands = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (commands.count == 0) {
		NSLog(@"Saving bundled data to core data store.");
		NSMutableArray *defaultCommands = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultCommands" ofType:@"json"]] options:kNilOptions error:nil];
		for (NSDictionary *dict in defaultCommands) {
			SamaritanData *data = [NSEntityDescription insertNewObjectForEntityForName:@"SamaritanData" inManagedObjectContext:managedObjectContext];
			data.displayString = dict[@"displayString"];
			data.tags = dict[@"tags"];
		}
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Can't Save : %@, %@", error, [error localizedDescription]);
		}
		if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showsIntro"])
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showsIntro"];
	}
	
	fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	NSArray *themes = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if (themes.count == 0) {
		NSLog(@"Saving bundled themes to core data store.");
		NSMutableArray *defaultThemes = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultThemes" ofType:@"json"]] options:kNilOptions error:nil];
		for (NSDictionary *dict in defaultThemes) {
			 Themes *theme = [NSEntityDescription insertNewObjectForEntityForName:@"Themes" inManagedObjectContext:managedObjectContext];
			theme.themeName = dict[@"themeName"];
			theme.fontName = dict[@"fontName"];
			theme.foregroundRed = [dict[@"foregroundRed"] integerValue];
			theme.foregroundGreen = [dict[@"foregroundGreen"] integerValue];
			theme.foregroundBlue = [dict[@"foregroundBlue"] integerValue];
			theme.backgroundRed = [dict[@"backgroundRed"] integerValue];
			theme.backgroundGreen = [dict[@"backgroundGreen"] integerValue];
			theme.backgroundBlue = [dict[@"backgroundBlue"] integerValue];
			theme.blinkDuration = [dict[@"blinkDuration"] doubleValue];
		}
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Can't Save : %@, %@", error, [error localizedDescription]);
		}
		[[NSUserDefaults standardUserDefaults] setValue:@"Samaritan Black" forKey:@"selectedTheme"];
	}
	else {
		Themes *selectedTheme = [[themes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]] firstObject];
		[[UINavigationBar appearance] setBackgroundColor:selectedTheme.backgroundColor];
		[[UINavigationBar appearance] setBarTintColor:selectedTheme.backgroundColor];
		[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedTheme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:selectedTheme.fontName size:18.f]}];
		[[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedTheme.foregroundColor, NSFontAttributeName: [UIFont fontWithName:selectedTheme.fontName size:18.f]} forState:UIControlStateNormal];
		[SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
		[SVProgressHUD setBackgroundColor:selectedTheme.backgroundColor];
		[SVProgressHUD setForegroundColor:selectedTheme.foregroundColor];
		[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
	}
	
	// Setup WIT.AI
	
//	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//	[[AVAudioSession sharedInstance] setActive:YES error:nil];
//
//	[Wit sharedInstance].accessToken = @"FOCPPMITQVTZUSCP2TRINZPIIQVWDMRG";
//	//enabling detectSpeechStop will automatically stop listening the microphone when the user stop talking
//	[Wit sharedInstance].detectSpeechStop = WITVadConfigDetectSpeechStop;
//
	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainVC"];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showsIntro"])
		viewController = [storyboard instantiateViewControllerWithIdentifier:@"StartupVC"];
	self.window.rootViewController = viewController;
	[self.window makeKeyAndVisible];
	
	return YES;
}

+ (Themes *)currentTheme {
	NSFetchRequest *themesRequest = [NSFetchRequest fetchRequestWithEntityName:@"Themes"];
	[themesRequest setPredicate:[NSPredicate predicateWithFormat:@"themeName contains[cd] %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"selectedTheme"]]];
	NSArray *themes = [[self managedObjectContext] executeFetchRequest:themesRequest error:nil];
	Themes *theme = [themes firstObject];
	return theme;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.darkarmy.Samaritan" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Samaritan" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Samaritan.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

+ (NSManagedObjectContext *)managedObjectContext {
	NSManagedObjectContext *context = nil;
	id delegate = [[UIApplication sharedApplication] delegate];
	if ([delegate performSelector:@selector(managedObjectContext)]) {
		context = [delegate managedObjectContext];
	}
	return context;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
