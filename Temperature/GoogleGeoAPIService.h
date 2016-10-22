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

//TODO: should indicate somehow that these are private methods. Doesn't seem like Objective C has a strict public/private method indicator, more of a way to imply it
+ (void) makeLocationRequest:(NSString *) zipCode completionHandler:(void(^)(Location *location)) completionHandler;
+ (Location *) handleLocationResponse:(NSData *) data;
@end
