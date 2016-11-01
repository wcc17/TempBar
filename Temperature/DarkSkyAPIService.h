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

+ (void) makeWeatherRequest:(Location *) location completionHandler:(void(^)(NSNumber *temperature)) completionHandler;
+ (NSNumber *) handleWeatherResponse:(NSData *) data;

@end
