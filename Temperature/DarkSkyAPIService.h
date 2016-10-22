//
//  DarkSkyAPIService.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface DarkSkyAPIService : NSObject

+ (void) getTemperatureFromLocation:(Location *) location completionHandler:(void(^)(NSNumber *temperature)) completionHandler;

//TODO: should indicate somehow that these are private methods. Doesn't seem like Objective C has a strict public/private method indicator, more of a way to imply it
+ (void) makeWeatherRequest:(Location *) location completionHandler:(void(^)(NSNumber *temperature)) completionHandler;
+ (NSNumber *) handleWeatherResponse:(NSData *) data;

@end
