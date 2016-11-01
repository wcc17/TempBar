//
//  DarkSkyAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "DarkSkyAPIService.h"

@implementation DarkSkyAPIService

+ (void) makeWeatherRequest:(Location *) location completionHandler:(void(^)(NSNumber *temperature)) completionHandler {
    
    //TODO: get out of here
    //NSString *DARKSKY_API_KEY = @"fb30f9d966ec63fc374f93f2b5816b94"; for gmail email
    NSString *DARKSKY_API_KEY = @"8876a0ff367275b80e907e0fa4cb4c75";
    
    NSString *darkSkyURL = @"https://api.darksky.net/forecast";
    
    NSString *weatherURLString = [NSString stringWithFormat:@"%@/%@/%@,%@",
                                  darkSkyURL,
                                  DARKSKY_API_KEY,
                                  [NSString stringWithFormat:@"%lf", location.latitude],
                                  [NSString stringWithFormat:@"%lf", location.longitude]];
    
    NSURL *requestURL = [NSURL URLWithString:weatherURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        NSLog(@"Dark sky request made");
        
        NSNumber *temperature = [self handleWeatherResponse: data];
        completionHandler(temperature);
    }] resume];
}

+ (NSNumber *) handleWeatherResponse:(NSData *) data {
    NSLog(@"handling weather response");
    
    NSError *error = nil;
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error == nil) {
        NSDictionary *currentlyDict = [root objectForKey:@"currently"];
        NSNumber *temperature = [NSNumber numberWithInt:[[currentlyDict objectForKey:@"temperature"] intValue]];
        
        return temperature;
    }
    
    return nil;
}

@end
