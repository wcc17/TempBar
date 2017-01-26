//
//  LocationService.h
//  Temperature
//
//  Created by Christian Curry on 1/21/17.
//  Copyright © 2017 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationService : NSObject

+ (LocationService *) instance;

@property CLLocationManager* locationManager;
@property void(^completionHandler)(NSString* zipCode);
@property BOOL isRunning;

- (void) initializeLocationService:(void(^)(NSString* zipCode)) completionHandler;
- (void) startLocationServices;
- (void) handleZipCode:(NSArray*) placemarks :(NSError*) error;
- (void) stopLocationServices;

//delegate method
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
