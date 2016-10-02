//
//  LoadingData.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingData : NSObject

@property NSString *command;
@property NSInteger weight;
@property BOOL isSingle;

- (instancetype)initWithCommand:(NSString *)command andWeight:(NSInteger)weight;

+ (NSArray *)returnArrayFromBundledJSONFile:(NSString *)filename;
+ (NSArray *)returnArrayFromJSONFile:(NSString *)filePath;
+ (NSArray *)returnArrayFromJSONData:(id)data;

+ (NSInteger)totalWeightOfCommands:(NSArray *)commands;

@end
