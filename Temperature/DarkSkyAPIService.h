//
//  DarkSkyAPIService.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Weather.h"

@interface DarkSkyAPIService : NSObject

+ (void) makeWeatherRequest:(Location *) location completionHandler:(void(^)(Weather* weather)) completionHandler;
+ (Weather *) handleWeatherResponse:(NSData *) data;

@end
