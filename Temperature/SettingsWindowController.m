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
    BOOL autoUpdateLocation = [StatusBarController instance].autoUpdateLocation;
    
    //set the zip code
    [self.zipCodeTextField setStringValue:zipCodeFromStatusBar];
    
    //set the unit of time
    NSInteger timeUnitIndex = [self.refreshTimeUnitPopUp indexOfItemWithTitle:timeUnitFromStatusBar];
    [self.refreshTimeUnitPopUp selectItemAtIndex: (int)timeUnitIndex];
    
    //set the refresh time interval
    int refreshTime = [Util getSecondsFromTimeUnit: [self.refreshTimeUnitPopUp titleOfSelectedItem] :timeIntervalFromStatusBar];
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", refreshTime]];
    
    [self initializeAutoUpdateLocationCheckBox: autoUpdateLocation];
}

- (void) adjustWindowPosition {
    NSLog(@"Adjusting settings window position");
    
    //Puts at center of screen based on pos of status bar and dock. change [[window screen] frame] to [[window screen visibleFrame] to ignore status bar and dock
    CGFloat xPos = NSWidth([[self.settingsWindow screen] visibleFrame])/2 - NSWidth([self.settingsWindow frame])/2;
    CGFloat yPos = NSHeight([[self.settingsWindow screen] visibleFrame])/2 - NSHeight([self.settingsWindow frame])/2;
    
    [self.settingsWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([self.settingsWindow frame]), NSHeight([self.settingsWindow frame])) display:YES];
}

- (void) initializeAutoUpdateLocationCheckBox: (BOOL) autoUpdateLocation {
    //disable zip code text field if auto update is turned on
    NSInteger autoLocationState = 0;
    if(autoUpdateLocation == YES) {
        autoLocationState = 1;
    }
    [self.autoUpdateLocationCheckBox setState: autoLocationState];
    
    //force zip code fields to disable or enable
    [self onAutoUpdateLocationCheckBoxClick: nil];
}

//TODO: this only goes up, not down
- (IBAction)onTimeStepper:(NSStepper *)sender {
    self.refreshTimeInterval = [self.refreshTimeTextField intValue];
    self.refreshTimeInterval++;
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", self.refreshTimeInterval]];
}

- (IBAction)onLocationButtonClick:(NSButton *)sender {
    NSLog(@"location button clicked");
    [self startLocationServices];
}

- (IBAction)onAutoUpdateLocationCheckBoxClick:(id)sender {
    NSInteger value = [self.autoUpdateLocationCheckBox state];
    
    if(value == 0) {
        NSLog(@"Auto update disabled"); //Show value on screen
        [self.locationButton setEnabled:YES];
        [self.zipCodeTextField setEnabled:YES];
    } else if(value == 1) {
        NSLog(@"Auto update enabled"); //Show value on screen
        [self.locationButton setEnabled:NO];
        [self.zipCodeTextField setEnabled:NO];
    } else {
        NSLog(@"stop it");
    }
}

- (IBAction)onConfirmClick:(NSButton *)sender {
    NSString *zipCode = self.zipCodeTextField.stringValue;
    NSString *selectedTimeUnit = [self.refreshTimeUnitPopUp titleOfSelectedItem];
    NSString *timeText = self.refreshTimeTextField.stringValue;
    
    [[StatusBarController instance] updateStatusBarValues: timeText selectedTimeUnit: selectedTimeUnit zipCode: zipCode autoUpdateValue: [self.autoUpdateLocationCheckBox state]];
    //go ahead and refresh the temperature based on the new information set in this menu
    [[StatusBarController instance] setTemperatureFromLocation: zipCode];
    [self.settingsWindow close];
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}



//TODO: I think I want all of these to be in their own class. the obstacle tonight is updating the zip code text field after it happens
- (void) startLocationServices {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = (id<CLLocationManagerDelegate>) self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 1600; // 1600 meters ~= 1 mile
    
    [self.locationButton setHidden: YES];
    [self.locationProgressIndicator startAnimation: self];
    
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
        
        if(zipCode != nil) {
            [self.zipCodeTextField setStringValue:zipCode];
            
            NSLog(@"zip code retrieved as: %@", zipCode);
        }
        
        //TODO: should be checking if user wants location to automatically update when they move a certain distance
        [self.locationManager stopUpdatingLocation];
        [self.locationButton setHidden: NO];
        [self.locationProgressIndicator stopAnimation: self];
    }
    else {
        NSLog(@"Geocode failed with error %@", error); // Error handling must required
    }
}

@end
