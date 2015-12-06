//
//  AppDelegate.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//#define GLOBAL_TINT_COLOR UIColorFromRGBWithAlpha(0x3a5069, 1.f)
//#define GLOBAL_BACK_COLOR UIColorFromRGBWithAlpha(0xfcf9ee, 1.f)

#define SHOW_ALERT(alertMessage) [[[UIAlertView alloc] initWithTitle:@"Error" message:alertMessage delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil] show];

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (NSManagedObjectContext *)managedObjectContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

