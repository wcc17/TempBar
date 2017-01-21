//
//  StatusBarController.m
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "StatusBarController.h"

@implementation StatusBarController

+ (StatusBarController *) instance {
    static StatusBarController *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StatusBarController alloc] init];
    });
    
    return sharedInstance;
}

- (void) openSettings {
    //Initialize the settings window
    self.settingsWindowController = [[SettingsWindowController alloc] initWithWindowNibName:@"SettingsWindow"];
    
    //open the window
    [self.settingsWindowController showWindow:self];
}

- (void) initialize {
    //initialize the location object
    self.location = [[Location alloc] init];
    [self loadDefaults];
    
    //allocate menu and settings menu item
    self.statusBarMenu = [[StatusBarMenu alloc] init];
    [self.statusBarMenu initializeMenuItems: self.location
                 openSettingsWindowSelector:@"openSettings"
                 executeDarkSkyRequestSelector:@"executeDarkSkyRequestNoLocation"
                 statusBarController: self];
    
    [self setTemperatureFromLocation:self.location.zipCode];
}

//Get location from Google and then get the temperature from DarkSkyAPI
- (void) setTemperatureFromLocation: (NSString *) zipCode {
    
    [GoogleGeoAPIService makeLocationRequest:zipCode completionHandler:^(Location *loc){
        [self executeDarkSkyRequest: loc];
    }];
}

//Will run weather request without giving it a new location (reuses current zip)
- (void) executeDarkSkyRequestNoLocation {
    NSLog(@"Time interval passed, starting weather request process");
    [self executeDarkSkyRequest:nil];
}

//Makes a new weather request and sets the status bar temperature. Restarts the timer
- (void) executeDarkSkyRequest: (Location *) loc {
    if(loc != nil) {
        self.location = loc;
        
        NSLog(@"Latitude: %g", self.location.latitude);
        NSLog(@"Longitude: %g", self.location.longitude);
    }
    
    //execute darksky request and handle the data thats returned
    [DarkSkyAPIService makeWeatherRequest: self.location completionHandler:^(Weather* weather) {
        NSLog(@"recieved dark sky api response");
        NSLog(@"temperature: %@", weather.currentTemperature);
        NSLog(@"high temperature: %@", weather.highTemperature);
        NSLog(@"low temperature: %@", weather.lowTemperature);
        NSLog(@"current weather status: %@", weather.status);
        NSLog(@" ");
    
        [self.statusBarMenu setMenuItemValues:self.location weather: weather];
        [self handleRefreshTimer];
    }];
}

- (void) handleRefreshTimer {
    NSLog(@"Resetting the refresh timer");
    
    //if refreshTimer is nil, we're either just starting up the application or no time interval (0) was set
    if(self.refreshTimer != nil) {
        //timer has already triggered temperature request. just resetting to prepare for a new timer to start
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
    
    if(self.refreshTimeInterval > 0) {
        //making a new timer for each request so that the temperature refreshes later
        self.refreshTimer = [NSTimer timerWithTimeInterval:self.refreshTimeInterval
                                                    target:self
                                                  selector:@selector(executeDarkSkyRequestNoLocation)
                                                  userInfo:nil
                                                   repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void) handleWakeNotification {
    NSLog(@"Handling wake notification in StatusBarController");
    
    NSDate *now = [NSDate date];
    
    if( [now isGreaterThan: self.refreshTimer.fireDate]) {
        NSLog(@"Firing refresh timer after sleeping for more than the refresh time interval");
        [self.refreshTimer fire];
        [self handleRefreshTimer];
    }
}

- (void) updateStatusBarValues:(NSString *)timeText selectedTimeUnit:(NSString *)selectedTimeUnit zipCode:(NSString*) zipCode{
    //set the amount of time and the time unit in StatusBarController to save the values and reuse them. also set the new zip code
    self.refreshTimeInterval = [Util convertSecondsToTimeUnit:selectedTimeUnit :timeText];
    self.refreshTimeUnit = selectedTimeUnit;
    self.location.zipCode = zipCode;
    
    //go ahead and refresh the temperature based on the new information set in this menu
    [self setTemperatureFromLocation: zipCode];
    
    [self writeDefaults];
}

- (void) loadDefaults {
    //TODO: move these strings to Constants file
    //load the last set zip code (or default if its never been set before
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.location.zipCode = [defaults stringForKey:@"zipCode"];
    self.location.city = [defaults stringForKey:@"city"];
    self.location.stateLong = [defaults stringForKey:@"stateLong"];
    self.location.stateShort = [defaults stringForKey:@"stateShort"];
    self.location.countryLong = [defaults stringForKey:@"countryLong"];
    self.location.countryShort = [defaults stringForKey:@"countryShort"];
    self.refreshTimeInterval = (int)[defaults integerForKey:@"refreshTimeInterval"];
    self.refreshTimeUnit = [defaults stringForKey:@"refreshTimeUnit"];
    NSLog(@"");
}

- (void) writeDefaults {
    NSLog(@"StatusBarController: Writing defaults");
    
    //Write current user values to NSDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.location.zipCode forKey:@"zipCode"];
    [defaults setValue:self.location.city forKey:@"city"];
    [defaults setValue:self.location.stateLong forKey:@"stateLong"];
    [defaults setValue:self.location.stateShort forKey:@"stateShort"];
    [defaults setValue:self.location.countryShort forKey:@"countryShort"];
    [defaults setValue:self.location.countryLong forKey:@"countryLong"];
    [defaults setInteger:self.refreshTimeInterval forKey:@"refreshTimeInterval"];
    [defaults setValue:self.refreshTimeUnit forKey:@"refreshTimeUnit"];
    [defaults synchronize];
    
}

- (void) tearDown {
    [self writeDefaults];
}

@end
