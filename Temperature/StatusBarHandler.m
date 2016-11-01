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

- (void) initializeStatusMenu {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    self.statusItem.title = @"--°";
    
    // The image gets a blue background when the item is selected
    self.statusItem.highlightMode = YES;
    
    NSMenu *menu = [[NSMenu alloc] init];
    
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Settings" action:@selector(openSettings) keyEquivalent:@""];
    [settingsMenuItem setTarget:self];
    [menu addItem:settingsMenuItem];
    
    [menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [menu addItemWithTitle:@"Exit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = menu;
}

//Get location from Google and then get the temperature from DarkSkyAPI
- (void) setTemperatureFromLocation: (NSString *) zipCode {
    
    [GoogleGeoAPIService makeLocationRequest:zipCode completionHandler:^(Location *loc){
        [self executeDarkSkyRequest: loc];
    }];
}

//Makes a new weather request and sets the status bar temperature. Restarts the timer
- (void) executeDarkSkyRequest: (Location *) loc {
    //if refreshTimer is nil, we're either just starting up the application or no time interval (0) was set
    if(self.refreshTimer != nil) {
        [self.refreshTimer invalidate];
        self.refreshTimer = nil;
    }
    
    if(loc != nil) {
        self.location = loc;
        NSLog(@"%g", self.location.latitude);
        NSLog(@"%g", self.location.longitude);
    }
    
    //execute darksky request and handle the data thats returned
    [DarkSkyAPIService makeWeatherRequest: self.location completionHandler:^(NSNumber *temperature) {
        NSLog(@"preparing dark sky api request");
        NSLog(@"temperature: %d", [temperature intValue]);
        NSLog(@" ");
    
        self.statusItem.title = [NSString stringWithFormat:@"%@°", [temperature stringValue]];
        
        if(self.timeInterval > 0) {
            //making a new timer for each request so that the temperature refreshes later
            self.refreshTimer = [NSTimer timerWithTimeInterval:self.timeInterval
                                                        target:self
                                                      selector:@selector(executeDarkSkyRequestNoLocation)
                                                      userInfo:nil
                                                       repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
        }
    }];
}

//Only called after timer is done running. Will run weather request without giving it a new location
- (void) executeDarkSkyRequestNoLocation {
    NSLog(@"Time interval passed, starting weather request process");
    [self executeDarkSkyRequest:nil];
}

@end
