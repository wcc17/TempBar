//
//  StatusBarController.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SettingsWindowController.h"
#import "DarkSkyAPIService.h"
#import "GoogleGeoAPIService.h"
#import "StatusBarMenu.h"
#import "Util.h"

@interface StatusBarController : NSObject

@property (strong, nonatomic) SettingsWindowController *settingsWindowController;
@property (strong, nonatomic) NSTimer *refreshTimer;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) StatusBarMenu *statusBarMenu;
@property int weatherRequestRetries;
@property int locationRequestRetries;
@property int refreshTimeInterval;
@property NSString* refreshTimeUnit;
@property (strong, nonatomic) NSDate *sleepDate;

+ (StatusBarController *) instance;
- (void) openSettings;
- (void) initialize;
- (void) loadDefaults;
- (void) tearDown;
- (void) writeDefaults;
- (void) onLocationFound: (NSString*) zipCode;
- (void) setTemperatureFromLocation: (NSString *)zipCode;
- (void) executeDarkSkyRequest: (Location *) location;
- (void) executeDarkSkyRequestNoLocation;
- (void) handleRefreshTimer;
- (void) handleWakeNotification;
- (void) updateStatusBarValues:(NSString *)timeText selectedTimeUnit:(NSString *)selectedTimeUnit zipCode:(NSString*) zipCode;

@end
