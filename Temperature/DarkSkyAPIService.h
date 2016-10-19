//
//  DarkSkyAPIService.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DarkSkyAPIService : NSObject

@property float temperature;

+ (void) makeWeatherRequest:(double) latitude :(double) longitude;
+ (void) handleWeatherResponse:(NSData *) data;

@end
