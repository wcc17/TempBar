//
//  SettingsWindowController.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import "Util.h"

@interface SettingsWindowController : NSWindowController

@property (strong) IBOutlet NSWindow *settingsWindow;

@property CLLocationManager* locationManager;
@property int refreshTimeInterval;
@property (weak) IBOutlet NSTextField *zipCodeTextField;
@property (weak) IBOutlet NSTextField *refreshTimeTextField;
@property (weak) IBOutlet NSPopUpButton *refreshTimeUnitPopUp;
@property (weak) IBOutlet NSButton *locationButton;
@property (weak) IBOutlet NSProgressIndicator *locationProgressIndicator;
@property (weak) IBOutlet NSButton *autoUpdateLocationCheckBox;

- (IBAction)onConfirmClick:(NSButton *)sender;
- (IBAction)onCancelClick:(NSButton *)sender;
- (IBAction)onTimeStepper:(NSStepper *)sender;
- (IBAction)onLocationButtonClick:(NSButton *)sender;
- (IBAction)onAutoUpdateLocationCheckBoxClick:(id)sender;

- (void) adjustWindowPosition;
- (void) startLocationServices;
- (void) handleZipCode:(NSArray*) placemarks :(NSError*) error;
- (void) initializeAutoUpdateLocationCheckBox: (BOOL) autoUpdateLocation;

//delegate method
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;

@end
