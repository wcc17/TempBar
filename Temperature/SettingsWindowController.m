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
    self.locationService = [[LocationService alloc] init];
    
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

//TODO: this only goes up, not down
- (IBAction)onTimeStepper:(NSStepper *)sender {
    self.refreshTimeInterval = [self.refreshTimeTextField intValue];
    self.refreshTimeInterval++;
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", self.refreshTimeInterval]];
}

- (IBAction)onLocationButtonClick:(NSButton *)sender {
    NSLog(@"location button clicked");
    
    [self.locationButton setHidden: YES];
    [self.locationProgressIndicator startAnimation: self];
    [self.locationService startLocationServices:^(NSString* zipCode){
        [self onLocationFound:zipCode];
    }];
}

- (void) onLocationFound: (NSString*) zipCode {
    if(zipCode != nil) {
        [self.zipCodeTextField setStringValue:zipCode];
        
        NSLog(@"zip code retrieved as: %@", zipCode);
    }
    
    [self.locationButton setHidden: NO];
    [self.locationProgressIndicator stopAnimation: self];
    
    if([self isAutoUpdateLocation] == NO) {
        NSLog(@"Stopping location services");
        [self.locationService stopLocationServices];
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

- (BOOL) isAutoUpdateLocation {
    NSInteger value = [self.autoUpdateLocationCheckBox state];
    
    if(value == 1) {
        return YES;
    }
    
    return NO;
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}

@end

//- (void) initializeAutoUpdateLocationCheckBox: (BOOL) autoUpdateLocation {
//    //disable zip code text field if auto update is turned on
//    NSInteger autoLocationState = 0;
//    if(autoUpdateLocation == YES) {
//        autoLocationState = 1;
//    }
//    [self.autoUpdateLocationCheckBox setState: autoLocationState];
//
//    //force zip code fields to disable or enable
//    [self onAutoUpdateLocationCheckBoxClick: nil];
//}

//- (IBAction)onAutoUpdateLocationCheckBoxClick:(id)sender {
//    BOOL autoUpdateLocation = [self isAutoUpdateLocation];
//
//    if(autoUpdateLocation == YES) {
//        NSLog(@"Auto update enabled");
//        [self.locationButton setEnabled:NO];
//        [self.zipCodeTextField setEnabled:NO];
//
//        //go ahead and retrieve location and then keep location services on
//        [self.locationService startLocationServices:^(NSString* zipCode){
//            [self onLocationFound:zipCode];
//        }];
//    } else if(autoUpdateLocation == NO) {
//        NSLog(@"Auto update disabled");
//        [self.locationButton setEnabled:YES];
//        [self.zipCodeTextField setEnabled:YES];
//
//        //force location services to stop if they aren't already stopped
//        [self.locationService stopLocationServices];
//    }
//}
