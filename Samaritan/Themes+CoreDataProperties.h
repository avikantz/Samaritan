//
//  Themes+CoreDataProperties.h
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Themes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Themes (CoreDataProperties)

@property (nonatomic) int16_t backgroundRed;
@property (nonatomic) int16_t foregroundRed;
@property (nullable, nonatomic, retain) NSString *fontName;
@property (nullable, nonatomic, retain) NSString *themeName;
@property (nonatomic) int16_t backgroundGreen;
@property (nonatomic) int16_t backgroundBlue;
@property (nonatomic) int16_t foregroundGreen;
@property (nonatomic) int16_t foregroundBlue;
@property (nonatomic) double blinkDuration;

@end

NS_ASSUME_NONNULL_END
