//
//  GoogleGeoAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "GoogleGeoAPIService.h"

@implementation GoogleGeoAPIService

//TODO: can probably get rid of this method now
+ (void) getLocationFromZip:(NSString *) zipCode completionHandler:(void(^)(Location *location)) completionHandler {
    [self makeLocationRequest:zipCode completionHandler: completionHandler];
}

+ (void) makeLocationRequest:(NSString *) zipCode completionHandler:(void(^)(Location *location)) completionHandler {
    
    //TODO: get out of here
    NSString *GOOGLE_API_KEY = @"AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA";
    
    NSString *locationURLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=%@",
                                   zipCode,
                                   GOOGLE_API_KEY];
    
    NSURL *requestURL = [NSURL URLWithString:locationURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        [self handleLocationResponse: data completionHandler: completionHandler];
    }] resume];
}

+ (void) handleLocationResponse:(NSData *) data completionHandler:(void(^)(Location *location)) completionHandler {
    //handle response
    NSLog(@"handling response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //NSLog(test);
    
    Location *location = [[Location alloc] init];
    location.latitude = 12345;
    location.longitude = 56789;
    completionHandler(location);
}

@end
