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

//TODO: move to its own class probably
- (void) setTemperatureFromLocation: (NSString *) zipCode {
    
    [GoogleGeoAPIService getLocationFromZip:zipCode completionHandler:^(Location *location){
        NSLog(@"whatup tho");
        
        if(location != nil) {
            NSLog(@"%g", location.latitude);
            NSLog(@"%g", location.longitude);
            
            //need a callback for this as well I guess
            [DarkSkyAPIService makeWeatherRequest: location completionHandler:^(NSNumber *temperature) {
                NSLog(@"handling temperature stuff now");
                NSLog(@"temperature in Lexington: %d", [temperature intValue]);
                
                self.statusItem.title = [NSString stringWithFormat:@"%@°", [temperature stringValue]];
            }];
        }
    }];
}

@end
