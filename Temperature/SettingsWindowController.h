//
//  SettingsWindowController.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LocationService.h"
#import "Util.h"

@interface SettingsWindowController : NSWindowController

@property (strong) LocationService* locationService;
@property (strong) IBOutlet NSWindow* settingsWindow;
@property int refreshTimeInterval;
@property (weak) IBOutlet NSTextField *zipCodeTextField;
@property (weak) IBOutlet NSTextField *refreshTimeTextField;
@property (weak) IBOutlet NSPopUpButton *refreshTimeUnitPopUp;
@property (weak) IBOutlet NSButton *locationButton;
@property (weak) IBOutlet NSProgressIndicator *locationProgressIndicator;

- (IBAction)onConfirmClick:(NSButton *)sender;
- (IBAction)onCancelClick:(NSButton *)sender;
- (IBAction)onTimeStepper:(NSStepper *)sender;
- (IBAction)onLocationButtonClick:(NSButton *)sender;
- (void) onLocationFound: (NSString*) zipCode;

- (void) adjustWindowPosition;

@end
