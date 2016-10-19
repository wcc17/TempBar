//
//  DarkSkyAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "DarkSkyAPIService.h"

@implementation DarkSkyAPIService

+ (void) makeWeatherRequest:(double) latitude :(double) longitude {
    //https://api.darksky.net/forecast/fb30f9d966ec63fc374f93f2b5816b94/37.8267,-122.4233
    
    //TODO: remove
    latitude = 37.8267;
    longitude = -122.4233;
    
    //TODO: get out of here
    NSString *DARKSKY_API_KEY = @"fb30f9d966ec63fc374f93f2b5816b94";
    
    NSString *darkSkyURL = @"https://api.darksky.net/forecast";
    
    NSString *weatherURLString = [NSString stringWithFormat:@"%@/%@/%@,%@",
                                  darkSkyURL,
                                  DARKSKY_API_KEY,
                                  [NSString stringWithFormat:@"%lf", latitude],
                                  [NSString stringWithFormat:@"%lf", longitude]];
    
    NSURL *requestURL = [NSURL URLWithString:weatherURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        [self handleWeatherResponse:data];
    }] resume];
}

+ (void) handleWeatherResponse:(NSData *) data {
    NSLog(@"handling weather response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    NSLog(test);
}

@end
