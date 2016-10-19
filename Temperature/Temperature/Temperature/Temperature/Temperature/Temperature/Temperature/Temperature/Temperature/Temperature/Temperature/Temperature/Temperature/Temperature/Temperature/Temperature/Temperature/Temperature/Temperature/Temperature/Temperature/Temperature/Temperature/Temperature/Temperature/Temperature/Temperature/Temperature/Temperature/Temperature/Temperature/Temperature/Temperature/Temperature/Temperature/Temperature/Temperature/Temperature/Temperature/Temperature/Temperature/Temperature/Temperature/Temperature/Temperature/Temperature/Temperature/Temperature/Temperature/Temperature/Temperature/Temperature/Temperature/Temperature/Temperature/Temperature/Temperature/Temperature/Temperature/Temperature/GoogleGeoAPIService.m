//
//  GoogleGeoAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "GoogleGeoAPIService.h"

@implementation GoogleGeoAPIService

+ (void) makeLocationRequest:(NSString *) zipCode {
    /**
     *https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA
     **/
    
    //TODO: get out of here
    NSString *GOOGLE_API_KEY = @"AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA";
    NSString *locationURL = @"https://maps.googleapis.com/maps/api/geocode/json?address=40330&key=";
    
    locationURL = [locationURL stringByAppendingString:GOOGLE_API_KEY];
    NSURL *requestURL = [NSURL URLWithString:locationURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        [self handleLocationResponse:data];
    }] resume];
}

+ (void) handleLocationResponse:(NSData *) data {
    //handle response
    NSLog(@"handling response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(test);
}

@end
