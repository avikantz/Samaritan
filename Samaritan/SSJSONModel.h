//
//  SSJSONModel.h
//  SSJSONParse
//
//  Created by Shubham Sorte on 13/08/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSJSONModel;

@protocol SSJSONModelDelegate

- (void)jsonRequestDidCompleteWithResponse:(id)response model:(SSJSONModel*)JSONModel;

@end

@interface SSJSONModel : NSObject <NSURLConnectionDelegate>

@property (weak, nonatomic) id<SSJSONModelDelegate> delegate;
@property (strong) id parsedJsonData;
@property (strong)NSURL * Url;

-(void)sendRequestWithUrl:(NSURL*)Url;

- (instancetype)initWithDelegate:(id<SSJSONModelDelegate>)delegate;

@end
