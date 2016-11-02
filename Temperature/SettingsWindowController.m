//
//  SettingsWindowController.m
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "SettingsWindowController.h"
#import "StatusBarHandler.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSLog(@"Settings window opened");
    
    [self adjustWindowPosition];
    
    //TODO!!: look into enums for handling the time units instead of if elsing strings
    [self.timeUnitPopUp removeAllItems];
    [self.timeUnitPopUp addItemsWithTitles:@[ @"Second(s)", @"Minute(s)", @"Hour(s)", @"Day(s)" ]];
    
    NSString *zipCodeFromStatusBar = nil;
    if ([StatusBarHandler instance].location != nil) {
        zipCodeFromStatusBar = [StatusBarHandler instance].zipCode;
    }
    int timeIntervalFromStatusBar = [StatusBarHandler instance].timeInterval;
    NSString *timeUnitFromStatusBar = [StatusBarHandler instance].timeUnit;
    
    if(zipCodeFromStatusBar != nil) {
        [self.zipCodeTextField setStringValue:zipCodeFromStatusBar];
    }
    
    if(timeUnitFromStatusBar != nil) {
        NSInteger timeUnitIndex = [self.timeUnitPopUp indexOfItemWithTitle:timeUnitFromStatusBar];
        [self.timeUnitPopUp selectItemAtIndex: (int)timeUnitIndex];
        
        int refreshTime = [self getSecondsFromTimeUnit: [self.timeUnitPopUp titleOfSelectedItem] :timeIntervalFromStatusBar];
        [self.timeTextField setStringValue:[NSString stringWithFormat:@"%d", refreshTime]];
    } else {
        [self.timeTextField setStringValue:[NSString stringWithFormat:@"%d", 0]];
    }
}

- (void) adjustWindowPosition {
    NSLog(@"Adjusting settings window position");
    
    //This puts it at the literal center of the screen, not taking into account the space occupied by the dock and menu bar.
    //If you want to do that, change [[window screen] frame] to [[window screen visibleFrame].
    CGFloat xPos = NSWidth([[self.settingsWindow screen] visibleFrame])/2 - NSWidth([self.settingsWindow frame])/2;
    CGFloat yPos = NSHeight([[self.settingsWindow screen] visibleFrame])/2 - NSHeight([self.settingsWindow frame])/2;
    [self.settingsWindow setFrame:NSMakeRect(xPos, yPos, NSWidth([self.settingsWindow frame]), NSHeight([self.settingsWindow frame])) display:YES];
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}

- (IBAction)onTimeStepper:(NSStepper *)sender {
    self.timeInterval = [self.timeTextField intValue];
    self.timeInterval++;
    [self.timeTextField setStringValue:[NSString stringWithFormat:@"%d", self.timeInterval]];
}

- (IBAction)onConfirmClick:(NSButton *)sender {
    NSString *zipCode = self.zipCodeTextField.stringValue;
    
    //TODO!!: look into enums for handling the time units instead of if elsing strings
    NSString *selectedTimeUnit = [self.timeUnitPopUp titleOfSelectedItem];
    NSString *timeText = self.timeTextField.stringValue;
    
    //set the amount of time and the time unit in StatusBarHandler to save the values and reuse them. also set the new zip code
    [StatusBarHandler instance].timeInterval = [self handleTime:selectedTimeUnit :timeText];
    [StatusBarHandler instance].timeUnit = selectedTimeUnit;
    [StatusBarHandler instance].zipCode = zipCode;
    
    //go ahead and refresh the temperature based on the new information set in this menu
    [[StatusBarHandler instance] setTemperatureFromLocation: zipCode];
    [self.settingsWindow close];
}

- (int) handleTime:(NSString *)selectedTimeUnit :(NSString *) timeText {
    int refreshTime = [timeText intValue];
    
    //need to convert unit to seconds
    if([selectedTimeUnit isEqual:@"Minute(s)"]) {
        refreshTime *= MINUTE_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Hour(s)"]) {
        refreshTime *= HOUR_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Day(s)"]) {
        refreshTime *= DAY_IN_SECONDS;
    }
    
    NSLog(@"Refresh time: %d", refreshTime);
    
    return refreshTime;
}

- (int) getSecondsFromTimeUnit:(NSString *)selectedTimeUnit :(int) time {
    int refreshTime = time;
    
    //need to convert unit to seconds
    if([selectedTimeUnit isEqual:@"Minute(s)"]) {
        refreshTime /= MINUTE_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Hour(s)"]) {
        refreshTime /= HOUR_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Day(s)"]) {
        refreshTime /= DAY_IN_SECONDS;
    }
    
    NSLog(@"Refresh time: %d", refreshTime);
    
    return refreshTime;
}

@end
