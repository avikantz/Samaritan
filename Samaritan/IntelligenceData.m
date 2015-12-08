//
//  IntelligenceData.m
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import "IntelligenceData.h"

@implementation IntelligenceData

-(instancetype)init {
	if (self)
		self = [super init];
	return self;
}

-(instancetype)initWithAgency:(NSString *)agency andWeight:(NSInteger)weight {
	if (self) {
		self = [super init];
		self.agency = agency;
		self.weight = weight;
	}
	return self;
}

+(NSArray *)returnArrayFromBundledJSONFile:(NSString *)filename {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
	return [self returnArrayFromJSONFile:filePath];
}

+(NSArray *)returnArrayFromJSONFile:(NSString *)filePath {
	NSError *error;
	id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:&error];
	return [self returnArrayFromJSONData:data];
}

+(NSArray *)returnArrayFromJSONData:(id)data {
	NSMutableArray *array = [NSMutableArray new];
	for (id dict in data) {
		NSString *agencyName = dict[@"name"];
		NSInteger weight = [dict[@"weight"] integerValue];
		IntelligenceData *idata = [[IntelligenceData alloc] initWithAgency:agencyName andWeight:weight];
		[array addObject:idata];
	}
	return array;
}

+(NSInteger)totalWeightOfAgencies:(NSArray *)agencies {
	NSInteger weight = 0;
	for (IntelligenceData *idata in agencies)
		weight += idata.weight;
	return weight;
}


@end
