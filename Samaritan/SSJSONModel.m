//
//  SSJSONModel.m
//  SSJSONParse
//
//  Created by Shubham Sorte on 13/08/14.
//  Copyright (c) 2014 LUGManipal. All rights reserved.
//

#import "SSJSONModel.h"

@interface SSJSONModel(){
    
    NSMutableData * responseData;
    NSURL * currentUrl;
}

@end

@implementation SSJSONModel

-(instancetype)initWithDelegate:(id<SSJSONModelDelegate>)delegate
{
    if(self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

-(void)sendRequestWithUrl:(NSURL*)Url
{
    NSURLRequest * request = [NSURLRequest requestWithURL:Url];
    currentUrl = Url;
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    _parsedJsonData = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    //Check for Valid JSON
    if (_parsedJsonData == nil) {
        NSLog(@"For %@ ,the response is not a valid JSON\nCheck your URL or API response over a browser",(NSString*)currentUrl);
    }
    
    //Check for JSON Array or Object
    else{
        if ([_parsedJsonData isKindOfClass:[NSArray class]]) {
            NSLog(@"For %@ ,the Response JSON Data is an Array.\nAssign it to a NSArray",(NSString*)currentUrl);
        }
        else if([_parsedJsonData isKindOfClass:[NSDictionary class]]) {
            NSLog(@"For %@ ,the Response JSON Data is a JSON Object or Dicitionary.\nAssign it to a NSDictionary",(NSString*)currentUrl);
        }
        
        [self.delegate jsonRequestDidCompleteWithResponse:_parsedJsonData model:self];
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

@end
