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
    
    NSLog(@"[SettingsWindowController] - Settings window opened");
    
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
    
    //Get time stepper value for increasing/decreasing later
    [self.timeStepper setIntValue:refreshTime];
    
    self.isWaitingForLocationServices = NO;
}

- (void) adjustWindowPosition {
    NSLog(@"[SettingsWindowController] - Adjusting settings window position");
    
    //open window at front of screen
    [NSApp activateIgnoringOtherApps:YES];
    
    //Puts at center of screen based on pos of status bar and dock. change [[window screen] frame] to [[window screen visibleFrame] to ignore status bar and dock
    CGFloat xPos = NSWidth([[self.settingsWindow screen] visibleFrame])/2 - NSWidth([self.settingsWindow frame])/2;
    CGFloat yPos = NSHeight([[self.settingsWindow screen] visibleFrame])/2 - NSHeight([self.settingsWindow frame])/2;
    
    [self.settingsWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([self.settingsWindow frame]), NSHeight([self.settingsWindow frame])) display:YES];
}

- (IBAction)onTimeStepper:(NSStepper *)sender {
    [self.refreshTimeTextField setStringValue:[NSString stringWithFormat:@"%d", self.timeStepper.intValue]];
}

- (IBAction)onLocationButtonClick:(NSButton *)sender {
    [self.locationButton setHidden: YES];
    [self.locationProgressIndicator startAnimation: self];
    self.isWaitingForLocationServices = YES;
    [[LocationService instance] startLocationServices];
}

- (void) onLocationButtonComplete:(NSString *) zipCode {
    [self.locationButton setHidden: NO];
    [self.locationProgressIndicator stopAnimation: self];
    self.isWaitingForLocationServices = NO;
    
    self.zipCodeTextField.stringValue = zipCode;
}

- (IBAction)onConfirmClick:(NSButton *)sender {
    NSString *zipCode = self.zipCodeTextField.stringValue;
    NSString *selectedTimeUnit = [self.refreshTimeUnitPopUp titleOfSelectedItem];
    NSString *timeText = self.refreshTimeTextField.stringValue;
    
    [[StatusBarController instance] updateStatusBarValues: timeText selectedTimeUnit: selectedTimeUnit zipCode: zipCode];
    
    [self.settingsWindow close];
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}

@end
