//
//  DarkSkyAPIService.m
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "DarkSkyAPIService.h"

@implementation DarkSkyAPIService

+ (void) makeWeatherRequest:(Location *) location completionHandler:(void(^)(Weather* weather)) completionHandler {
    
    //TODO: get out of here
    NSString *DARKSKY_API_KEY = @"fb30f9d966ec63fc374f93f2b5816b94";    //gmail email
//    NSString *DARKSKY_API_KEY = @"8876a0ff367275b80e907e0fa4cb4c75";    //school email
    
    NSString *darkSkyURL = @"https://api.darksky.net/forecast";
    
    NSString *weatherURLString = [NSString stringWithFormat:@"%@/%@/%@,%@",
                                  darkSkyURL,
                                  DARKSKY_API_KEY,
                                  [NSString stringWithFormat:@"%lf", location.latitude],
                                  [NSString stringWithFormat:@"%lf", location.longitude]];
    
    NSURL *requestURL = [NSURL URLWithString:weatherURLString];
    
    //execute request and pass the temperature data to the completionHandler passed to this method
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        Weather *weather = nil;
        if(error == nil) {
            weather = [self handleWeatherResponse: data];
        }
        completionHandler(weather);
    }] resume];
}

+ (Weather *) handleWeatherResponse:(NSData *) data {
    NSLog(@"[DarkSkyAPIService] - Handling weather response");
    
    NSError *error = nil;
    NSDictionary *root = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error == nil) {
        NSDictionary *currentlyDict = [root objectForKey:@"currently"];
        NSNumber* temperature = [NSNumber numberWithInt:[[currentlyDict objectForKey:@"temperature"] intValue]];
        NSString* weatherStatus = [currentlyDict objectForKey:@"summary"];
        
        NSDictionary* dailyDict = [root objectForKey:@"daily"];
        NSArray* dataArray = [dailyDict objectForKey:@"data"];
        NSDictionary* todayDict = dataArray[0];
        NSNumber* highTemperature = [NSNumber numberWithInt:[[todayDict objectForKey:@"temperatureMax"] intValue]];
        NSNumber* lowTemperature = [NSNumber numberWithInt:[[todayDict objectForKey:@"temperatureMin"] intValue]];
        
        Weather* weather = [[Weather alloc] init];
        weather.currentTemperature = temperature;
        weather.highTemperature = highTemperature;
        weather.lowTemperature = lowTemperature;
        weather.status = weatherStatus;
        
        return weather;
    }
    
    //will return nil if error happens. completion handler will handle the nil value accordingly
    //by retrying or just throwing the request away and trying again later
    return nil;
}

@end
