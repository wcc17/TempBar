//
//  StatusBarHandler.m
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "StatusBarHandler.h"

@implementation StatusBarHandler

+ (StatusBarHandler *) instance {
    static StatusBarHandler *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StatusBarHandler alloc] init];
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
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar if no temperature is set yet
    self.statusItem.title = @"--°";
    
    // The image gets a blue background when the item is selected
    self.statusItem.highlightMode = YES;
    
    //initialize the location object
    self.location = [[Location alloc] init];
    
    //allocate menu and settings menu item
    NSMenu *menu = [[NSMenu alloc] init];
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Settings" action:@selector(openSettings) keyEquivalent:@""];
    [settingsMenuItem setTarget:self];
    
    //add items to the menu
    [menu addItem:settingsMenuItem];
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Exit" action:@selector(terminate:) keyEquivalent:@""];
    
    //set the statusmenuItem menu to the new menu
    self.statusItem.menu = menu;
    
    //load the last set zip code (or default if its never been set before
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.location.zipCode = [defaults stringForKey:@"zipCode"];
    self.timeInterval = (int)[defaults integerForKey:@"refreshTimeInterval"];
    self.timeUnit = [defaults stringForKey:@"refreshTimeUnit"];
    
    [self setTemperatureFromLocation:self.location.zipCode];
}

//Get location from Google and then get the temperature from DarkSkyAPI
- (void) setTemperatureFromLocation: (NSString *) zipCode {
    
    [GoogleGeoAPIService makeLocationRequest:zipCode completionHandler:^(Location *loc){
        [self executeDarkSkyRequest: loc];
    }];
}

//Only called after timer is done running. Will run weather request without giving it a new location
- (void) executeDarkSkyRequestNoLocation {
    NSLog(@"Time interval passed, starting weather request process");
    [self executeDarkSkyRequest:nil];
}

//Makes a new weather request and sets the status bar temperature. Restarts the timer
- (void) executeDarkSkyRequest: (Location *) loc {
    if(loc != nil) {
        //self.location = nil; not sure if i need to worry about this because of ARC
        self.location = loc;
        
        NSLog(@"Latitude: %g", self.location.latitude);
        NSLog(@"Longitude: %g", self.location.longitude);
    }
    
    //execute darksky request and handle the data thats returned
    [DarkSkyAPIService makeWeatherRequest: self.location completionHandler:^(NSNumber *temperature) {
        NSLog(@"recieved dark sky api response");
        NSLog(@"temperature: %d", [temperature intValue]);
        NSLog(@" ");
    
        self.statusItem.title = [NSString stringWithFormat:@"%@°", [temperature stringValue]];
        
        [self handleRefreshTimer];
    }];
}

- (void) handleRefreshTimer {
    //if refreshTimer is nil, we're either just starting up the application or no time interval (0) was set
    if(self.refreshTimer != nil) {
        //timer has already triggered temperature request. just resetting to prepare for a new timer to start
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
    
    if(self.timeInterval > 0) {
        //making a new timer for each request so that the temperature refreshes later
        self.refreshTimer = [NSTimer timerWithTimeInterval:self.timeInterval
                                                    target:self
                                                  selector:@selector(executeDarkSkyRequestNoLocation)
                                                  userInfo:nil
                                                   repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void) tearDown {
    NSLog(@"Writing zip code, time interval, time unit to NSDefaults");
    
    //Write current user values to NSDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.location.zipCode forKey:@"zipCode"];
    [defaults setInteger:self.timeInterval forKey:@"refreshTimeInterval"];
    [defaults setValue:self.timeUnit forKey:@"refreshTimeUnit"];
    [defaults synchronize];
}

@end
