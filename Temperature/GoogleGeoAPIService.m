//
//  GoogleGeoAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "GoogleGeoAPIService.h"

@implementation GoogleGeoAPIService

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
        
        Location *location = [self handleLocationResponse: data :zipCode];
        completionHandler(location);
    }] resume];
}

+ (Location *) handleLocationResponse:(NSData *) data :(NSString *) zipCode {
    //handle response
    NSLog(@"handling response");
    
    NSError *error = nil;
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error == nil) {
        NSArray *resultsArray = [root objectForKey:@"results"];
        NSDictionary *resultsDict = [resultsArray objectAtIndex:0];
        
        NSString *city;
        NSString *stateLong;
        NSString *stateShort;
        NSString *countryLong;
        NSString *countryShort;
        NSArray *addressComponentsDict = [resultsDict objectForKey:@"address_components"];
        for(NSDictionary *dict in addressComponentsDict) {
            NSArray *types = [dict objectForKey:@"types"];
            
            NSString *longName = [dict objectForKey:@"long_name"];
            NSString *shortName = [dict objectForKey:@"short_name"];
            if([types containsObject:@"locality"]) {
                //Lexington
                city = longName;
            } else if([types containsObject:@"administrative_area_level_1"]) {
                //long_name: Kentucky
                //short_name: KY
                stateLong = longName;
                stateShort = shortName;
            } else if([types containsObject:@"country"]) {
                //long_name: United States
                //short_name: US
                countryLong = longName;
                countryShort = shortName;
            }
        }
        
        NSDictionary *geometryDict = [resultsDict objectForKey:@"geometry"];
        NSDictionary *locationDict = [geometryDict objectForKey:@"location"];
        
        Location *location = [[Location alloc] init];
        location.zipCode = zipCode;
        location.city = city;
        location.stateLong = stateLong;
        location.stateShort = stateShort;
        location.countryLong = countryLong;
        location.countryShort = countryShort;
        location.latitude = [[locationDict objectForKey:@"lat"] doubleValue];
        location.longitude = [[locationDict objectForKey:@"lng"] doubleValue];
        
        return location;
    }
    
    return nil;
}

@end
