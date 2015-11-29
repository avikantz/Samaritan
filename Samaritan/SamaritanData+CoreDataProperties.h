//
//  SamaritanData+CoreDataProperties.h
//  Samaritan
//
//  Created by Avikant Saini on 11/29/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SamaritanData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SamaritanData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *displayString;
@property (nullable, nonatomic, retain) NSString *tags;

@end

NS_ASSUME_NONNULL_END
