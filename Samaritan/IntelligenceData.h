//
//  IntelligenceData.h
//  Samaritan Loader
//
//  Created by Avikant Saini on 12/7/15.
//  Copyright © 2015 Dark Army. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntelligenceData : NSObject

@property NSString *agency;
@property NSInteger weight;

-(instancetype)initWithAgency:(NSString *)agency andWeight:(NSInteger)weight;

+(NSArray *)returnArrayFromBundledJSONFile:(NSString *)filename;
+(NSArray *)returnArrayFromJSONFile:(NSString *)filePath;
+(NSArray *)returnArrayFromJSONData:(id)data;

+(NSInteger)totalWeightOfAgencies:(NSArray *)agencies;

@end
