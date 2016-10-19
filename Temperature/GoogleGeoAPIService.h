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

+ (Location *) getLocationFromZip:(NSString *) zipCode;
+ (void) makeLocationRequest:(NSString *) zipCode :(Location *) location;
+ (void) handleLocationResponse:(NSData *) data :(Location *) location; 

@end
