//
//  LocationService.m
//  Temperature
//
//  Created by Christian Curry on 1/21/17.
//  Copyright © 2017 Christian Curry. All rights reserved.
//

#import "LocationService.h"

@implementation LocationService

- (void) startLocationServices:(void(^)(NSString* zipCode)) completionHandler {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = (id<CLLocationManagerDelegate>) self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = 1000; // meters    
    self.completionHandler = completionHandler;
    
    [self.locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    // If the event is recent, do something with it.
    if (fabs(howRecent) < 15.0) {
        //TODO: need to check if user wants to keep updating location in the background when they move around
        [self.locationManager stopUpdatingLocation];
        
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
        NSLog(@"Geocode failed with error %@", error); // Error handling must required
        self.completionHandler(nil);
    }
}

- (void) stopLocationServices {
    [self.locationManager stopUpdatingLocation];
}

@end
