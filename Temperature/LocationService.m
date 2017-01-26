//
//  LocationService.m
//  Temperature
//
//  Created by Christian Curry on 1/21/17.
//  Copyright © 2017 Christian Curry. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

+ (LocationService *) instance {
    static LocationService *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LocationService alloc] init];
    });
    
    return sharedInstance;
}

- (void) initializeLocationService:(void(^)(NSString* zipCode)) completionHandler {
    self.completionHandler = completionHandler;
    self.isRunning = NO;
}

- (void) startLocationServices {
    //If startLocationServices is called then we're resetting things, so go ahead and stop location services first
    [self stopLocationServices];
    
    NSLog(@"[LocationService] - Starting location services");
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = (id<CLLocationManagerDelegate>) self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = 10; // meters
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    
    if(self.isRunning == NO) {
        self.isRunning = YES;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            [self handleZipCode: placemarks :error];
        }];
    }
}

- (void) handleZipCode:(NSArray*) placemarks :(NSError*) error {
    if (!error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        NSString* zipCode = [[NSString alloc]initWithString:placemark.postalCode];
        self.completionHandler(zipCode);
    }
    else {
        NSLog(@"[LocationService] - Geocode failed with error %@", error); // Error handling must required
        self.completionHandler(nil);
    }
}

- (void) stopLocationServices {
    NSLog(@"[LocationService] - Stopping location services");
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

@end
