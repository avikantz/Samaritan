//
//  LoadingData.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "LoadingData.h"

@implementation LoadingData

- (instancetype)init {
	if (self)
		self = [super init];
	return self;
}

- (instancetype)initWithCommand:(NSString *)command andWeight:(NSInteger)weight {
	if (self) {
		self = [super init];
		self.command = command;
		self.weight = weight;
		self.isSingle = NO;
	}
	return self;
}

+ (NSArray *)returnArrayFromBundledJSONFile:(NSString *)filename {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
	return [self returnArrayFromJSONFile:filePath];
}

+ (NSArray *)returnArrayFromJSONFile:(NSString *)filePath {
	NSError *error;
	id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:&error];
	return [self returnArrayFromJSONData:data];
}

+ (NSArray *)returnArrayFromJSONData:(id)data {
	NSMutableArray *array = [NSMutableArray new];
	for (id dict in data) {
		NSString *commandName = dict[@"command"];
		NSInteger sequence = [dict[@"sequence"] integerValue];
		NSInteger weight = [dict[@"weight"] integerValue];
		if (sequence == 0) {
			LoadingData *ldata = [[LoadingData alloc] initWithCommand:commandName andWeight:weight];
			ldata.isSingle = YES;
			[array addObject:ldata];
		}
		else {
			for (NSInteger i = 1; i <= sequence; ++i) {
				LoadingData *ldata = [[LoadingData alloc] initWithCommand:[NSString stringWithFormat:@"%@.%.3li", commandName, (long) i] andWeight:weight];
				[array addObject:ldata];
			}
		}
	}
	return array;
}

+ (NSInteger)totalWeightOfCommands:(NSArray *)commands {
	NSInteger weight = 0;
	for (LoadingData *ldata in commands)
		weight += ldata.weight;
	return weight;
}

@end
