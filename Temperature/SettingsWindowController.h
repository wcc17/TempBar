//
//  SettingsWindowController.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsWindowController : NSWindowController

#define MINUTE_IN_SECONDS (60)
#define HOUR_IN_SECONDS (3600)
#define DAY_IN_SECONDS (86400)

@property int timeInterval;
@property (strong) IBOutlet NSWindow *settingsWindow;

@property (weak) IBOutlet NSTextField *zipCodeTextField;
@property (weak) IBOutlet NSTextField *timeTextField;
@property (weak) IBOutlet NSPopUpButton *timeUnitPopUp;

- (IBAction)onConfirmClick:(NSButton *)sender;
- (IBAction)onCancelClick:(NSButton *)sender;
- (IBAction)onTimeStepper:(NSStepper *)sender;

- (void)adjustWindowPosition;
- (int)convertSecondsToTimeUnit: (NSString*)selectedTimeUnit :(NSString*) timeText;
- (int)getSecondsFromTimeUnit:(NSString *)selectedTimeUnit :(int) time;

@end
