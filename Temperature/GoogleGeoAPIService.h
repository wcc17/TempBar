//
//  GoogleGeoAPIService.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface GoogleGeoAPIService : NSObject

+ (void) getLocationFromZip:(NSString *) zipCode completionHandler:(void(^)(Location* location)) completionHandler;
+ (void) makeLocationRequest:(NSString *) zipCode completionHandler:(void(^)(Location *location)) completionHandler;
+ (void) handleLocationResponse:(NSData *) data completionHandler:(void(^)(Location *location)) completionHandler;

@end
