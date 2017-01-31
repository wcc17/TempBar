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
    
    //assign completion handler regardless if location services will be started yet
    [[LocationService instance] initializeLocationService:^(NSString* zipCode){
        [[StatusBarController instance] onLocationFound:zipCode];
    }];
    
    //start location services if auto update is enabled
    if(self.autoUpdateLocation == YES) {
        [[LocationService instance] startLocationServices];
    } else {
        [self setTemperatureFromLocation:self.location.zipCode];
    }
}

//Get location from Google and then get the temperature from DarkSkyAPI
- (void) setTemperatureFromLocation: (NSString *) zipCode {
    [GoogleGeoAPIService makeLocationRequest:zipCode completionHandler:^(Location *loc){
        if(loc != nil) {
            self.locationRequestRetries = 0;
            [self executeDarkSkyRequest: loc];
        } else {
            self.locationRequestRetries++;
            
            if(self.locationRequestRetries < 3) {
                //TODO: any way to easilyi add a time delay here?
                NSLog(@"[StatusBarController] - retrying location request");
                [self setTemperatureFromLocation:zipCode];
            } else {
                //TODO: need to show user error message
                //throw away this request and reset retries until request is triggered again in normal way
                self.locationRequestRetries = 0;
            }
        }
    }];
}

- (void) onLocationFound: (NSString*) zipCode {
    NSLog(@"[StatusBarController] - Zip code retrieved as: %@", zipCode);
    
    //stop the settings animations after the location is found if the settings window initiated the request
    //don't go ahead and grab location and weather info if settings is waiting for the zip code. that will happen when user clicks confirms
    if(self.settingsWindowController != nil) {
        if(self.settingsWindowController.isWaitingForLocationServices == YES) {
            [self.settingsWindowController onLocationButtonComplete: zipCode];
        } else if(zipCode != nil) {
            [self setTemperatureFromLocation:zipCode];
        }
    } else if(zipCode != nil) {
        [self setTemperatureFromLocation:zipCode];
    }
    
    //If auto update is turned off, turn off location services
    if(self.autoUpdateLocation != YES) {
        [[LocationService instance] stopLocationServices];
    }
    
    //let LocationService look for another location if it needs to now
    if([LocationService instance].isRunning == YES) {
        [LocationService instance].isRunning = NO;
    }
}

//Will run weather request without giving it a new location (reuses current zip)
- (void) executeDarkSkyRequestNoLocation {
    NSLog(@"[StatusBarController] - Time interval passed, starting weather request process");
    [self executeDarkSkyRequest:nil];
}

//Makes a new weather request and sets the status bar temperature. Restarts the timer
- (void) executeDarkSkyRequest: (Location *) loc {
    if(loc != nil) {
        self.location = loc;
        
        NSLog(@"[StatusBarController] - Latitude: %g", self.location.latitude);
        NSLog(@"[StatusBarController] - Longitude: %g", self.location.longitude);
    }
    
    //execute darksky request and handle the data thats returned
    [DarkSkyAPIService makeWeatherRequest: self.location completionHandler:^(Weather* weather) {
        if(weather != nil) {
            self.weatherRequestRetries = 0;
            NSLog(@"[StatusBarController] - recieved dark sky api response");
            NSLog(@"[StatusBarController] - temperature: %@", weather.currentTemperature);
            NSLog(@"[StatusBarController] - high temperature: %@", weather.highTemperature);
            NSLog(@"[StatusBarController] - low temperature: %@", weather.lowTemperature);
            NSLog(@"[StatusBarController] - current weather status: %@", weather.status);
            
            [self.statusBarMenu setMenuItemValues:self.location weather: weather];
            [self handleRefreshTimer];
        } else {
            self.weatherRequestRetries++;
            
            if(self.weatherRequestRetries < 3) {
                //TODO: any way to easily add a time delay here?
                NSLog(@"[StatusBarController] - retrying weather request");
                [self executeDarkSkyRequest:loc];
            } else {
                //TODO: need to show user error message
                //throw away this request and reset retries until request is triggered again in normal way
                self.weatherRequestRetries = 0;
            }
        }
    }];
}

- (void) handleRefreshTimer {
    NSLog(@"[StatusBarController] - Resetting the refresh timer");
    
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
    NSLog(@"[StatusBarController] - Handling wake notification in StatusBarController");
    
    NSDate *now = [NSDate date];
    
    if( [now isGreaterThan: self.refreshTimer.fireDate]) {
        NSLog(@"[StatusBarController] - Firing refresh timer after sleeping for more than the refresh time interval");
        [self.refreshTimer fire];
        [self handleRefreshTimer];
    }
}

- (void) updateStatusBarValues:(NSString *)timeText selectedTimeUnit:(NSString *)selectedTimeUnit zipCode:(NSString*) zipCode isAutoUpdate:(BOOL) isAutoUpdate {
    //set the amount of time and the time unit in StatusBarController to save the values and reuse them. also set the new zip code
    self.refreshTimeInterval = [Util convertSecondsToTimeUnit:selectedTimeUnit :timeText];
    self.refreshTimeUnit = selectedTimeUnit;
    self.location.zipCode = zipCode;
    self.autoUpdateLocation = isAutoUpdate;
    
    //start location services if auto update is checked
    if(isAutoUpdate == YES) {
        [[LocationService instance] startLocationServices];
    } else {
        //Need to stop location services or they'll stay on after user turns off auto update
        [[LocationService instance] stopLocationServices];
        
        //go ahead and refresh the temperature based on the new information set in this menu
        [self setTemperatureFromLocation: zipCode];
    }
    
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
    self.autoUpdateLocation = [defaults boolForKey:@"autoUpdateLocation"];
}

- (void) writeDefaults {
    NSLog(@"[StatusBarController] - Writing defaults");
    
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
    [defaults setBool:self.autoUpdateLocation forKey:@"autoUpdateLocation"];
    [defaults synchronize];
    
}

- (void) tearDown {
    [self writeDefaults];
}

@end
