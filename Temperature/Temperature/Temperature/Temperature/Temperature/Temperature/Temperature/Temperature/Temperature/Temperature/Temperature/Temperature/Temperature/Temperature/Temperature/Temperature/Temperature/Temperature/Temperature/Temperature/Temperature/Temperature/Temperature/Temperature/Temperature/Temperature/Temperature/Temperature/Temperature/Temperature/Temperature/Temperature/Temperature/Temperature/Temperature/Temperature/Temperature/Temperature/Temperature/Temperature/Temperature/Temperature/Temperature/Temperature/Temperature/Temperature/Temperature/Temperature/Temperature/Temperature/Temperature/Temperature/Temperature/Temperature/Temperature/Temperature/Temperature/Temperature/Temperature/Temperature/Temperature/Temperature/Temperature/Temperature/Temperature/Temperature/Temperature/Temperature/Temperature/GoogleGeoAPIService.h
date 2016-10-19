//
//  GoogleGeoAPIService.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleGeoAPIService : NSObject

+ (void) makeLocationRequest:(NSString *) zipCode;
+ (void) handleLocationResponse:(NSData *) data;

@end
