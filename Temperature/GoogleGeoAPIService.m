//
//  GoogleGeoAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "GoogleGeoAPIService.h"

@implementation GoogleGeoAPIService

+ (Location *) getLocationFromZip:(NSString *) zipCode {
    
    Location *location = [[Location alloc] init];
    
    [self makeLocationRequest:zipCode :location];
    
    return location;
}

+ (void) makeLocationRequest:(NSString *) zipCode :(Location *) location {
    
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
        [self handleLocationResponse: data :location];
    }] resume];
}

+ (void) handleLocationResponse:(NSData *) data :(Location *) location {
    //handle response
    NSLog(@"handling response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    location.longitude = 456;
    location.latitude = 1256;
    
    //NSLog(test);
}

@end
