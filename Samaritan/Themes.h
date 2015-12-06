//
//  Themes.h
//  Samaritan
//
//  Created by Avikant Saini on 12/6/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Themes : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@property (nonatomic, readwrite) UIColor *backgroundColor;
@property (nonatomic, readwrite) UIColor *foregroundColor;

@end

NS_ASSUME_NONNULL_END

#import "Themes+CoreDataProperties.h"
