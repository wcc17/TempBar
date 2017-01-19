//
//  SettingsWindowController.m
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "SettingsWindowController.h"
#import "StatusBarController.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSLog(@"Settings window opened");
    
    [self adjustWindowPosition];
    
    //Initialize Pop Up button for units of time
    [self.refreshTimeUnitPopUp removeAllItems];
    [self.refreshTimeUnitPopUp addItemsWithTitles:@[ @"Second(s)", @"Minute(s)", @"Hour(s)", @"Day(s)" ]];
    
    //Get zip code, time interval, and units of time from StatusBarController
    NSString *zipCodeFromStatusBar = zipCodeFromStatusBar = [StatusBarController instance].location.zipCode;
    int timeIntervalFromStatusBar = [StatusBarController instance].refreshTimeInterval;
    NSString *timeUnitFromStatusBar = [StatusBarController instance].refreshTimeUnit;
    
    //set the zip code
    [self.zipCodeTextField setStringValue:zipCodeFromStatusBar];
    
    //set the unit of time
    NSInteger timeUnitIndex = [self.refreshTimeUnitPopUp indexOfItemWithTitle:timeUnitFromStatusBar];
    [self.refreshTimeUnitPopUp selectItemAtIndex: (int)timeUnitIndex];
    
    //set the refresh time interval
    int refreshTime = [Util getSecondsFromTimeUnit: [self.refreshTimeUnitPopUp titleOfSelectedItem] :timeIntervalFromStatusBar];
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", refreshTime]];
}

- (void) adjustWindowPosition {
    NSLog(@"Adjusting settings window position");
    
    //Puts at center of screen based on pos of status bar and dock. change [[window screen] frame] to [[window screen visibleFrame] to ignore status bar and dock
    CGFloat xPos = NSWidth([[self.settingsWindow screen] visibleFrame])/2 - NSWidth([self.settingsWindow frame])/2;
    CGFloat yPos = NSHeight([[self.settingsWindow screen] visibleFrame])/2 - NSHeight([self.settingsWindow frame])/2;
    
    [self.settingsWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([self.settingsWindow frame]), NSHeight([self.settingsWindow frame])) display:YES];
}

- (IBAction)onTimeStepper:(NSStepper *)sender {
    self.refreshTimeInterval = [self.refreshTimeTextField intValue];
    self.refreshTimeInterval++;
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", self.refreshTimeInterval]];
}

- (IBAction)onLocationButtonClick:(NSButton *)sender {
    NSLog(@"location button clicked");
    
    [self initializeLocationServices];
}

- (IBAction)onAutoUpdateLocationCheckBoxClick:(id)sender {
}

- (IBAction)onConfirmClick:(NSButton *)sender {
    NSString *zipCode = self.zipCodeTextField.stringValue;
    NSString *selectedTimeUnit = [self.refreshTimeUnitPopUp titleOfSelectedItem];
    NSString *timeText = self.refreshTimeTextField.stringValue;
    
    //set the amount of time and the time unit in StatusBarController to save the values and reuse them. also set the new zip code
    //TODO: move this to a method in StatusBarController
    [StatusBarController instance].refreshTimeInterval = [Util convertSecondsToTimeUnit:selectedTimeUnit :timeText];
    [StatusBarController instance].refreshTimeUnit = selectedTimeUnit;
    [StatusBarController instance].location.zipCode = zipCode;
    
    //go ahead and refresh the temperature based on the new information set in this menu
    [[StatusBarController instance] setTemperatureFromLocation: zipCode];
    [self.settingsWindow close];
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}

- (void) initializeLocationServices {
    //STARTING THE STANDARD LOCATION SERVICES
    
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
//    if([CLLocationManager locationServicesEnabled]) {
//        //even if they're disabled, the program will still prompt if the application tries to use them
//        //will come back to this
//    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationButton setHidden: YES];
    [self.locationManager startUpdatingLocation];
    [self.locationProgressIndicator startAnimation: self];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void) locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
    
    //TODO: need to check if user wants to keep updating location in the background when they move around
    [self.locationManager stopUpdatingLocation];
    
    //TODO: this completion handler needs to be in its own function or whatever
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSString* zipCode = nil;
         if (!error) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             zipCode = [[NSString alloc]initWithString:placemark.postalCode];
             NSLog(@"%@",zipCode);
         }
         else {
             NSLog(@"Geocode failed with error %@", error); // Error handling must required
         }
         
         //TODO: could possibly put this in its own completionHandler to seperate Location stuff from SettingsWindow
         if(zipCode != nil) {
            [self.zipCodeTextField setStringValue:zipCode];
         }
         
         //TODO: should be checking if user wants location to automatically update when they move a certain distance
         [self.locationManager stopUpdatingLocation];
         [self.locationButton setHidden: NO];
         [self.locationProgressIndicator stopAnimation: self];
     }];
}

@end
