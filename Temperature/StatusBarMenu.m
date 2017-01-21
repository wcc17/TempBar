//
//  StatusBarMenu.m
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu

NSString *const LOCATION_STRING_FORMAT = @"%@, %@ %@ %@";
NSString *const WEATHER_INFO_STRING_FORMAT = @"H: %@ L: %@";
NSString *const WEATHER_STATUS_STRING_FORMAT = @"Currently: %@";
NSString *const TEMPERATURE_STRING_FORMAT = @"%@°";

- (id) init {
    self = [super init];
    
    if(self) {
        [self initialize];
    }
    
    return self;
}

- (void) initialize {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar if no temperature is set yet
    self.statusItem.title = @"--°";
    
    // The image gets a blue background when the item is selected
    self.statusItem.highlightMode = YES;
}

- (void) initializeMenuItems: (Location *) location
                        openSettingsWindowSelector:(NSString *) openSettingsWindowSelector
                        executeDarkSkyRequestSelector:(NSString *) executeDarkSkyRequestSelector
                        statusBarController: (StatusBarController *) statusBarController {
    
    NSString *locationString = [NSString stringWithFormat: LOCATION_STRING_FORMAT, location.city, location.stateShort, location.countryShort, location.zipCode];
    NSString *weatherInfoString = [NSString stringWithFormat: WEATHER_INFO_STRING_FORMAT, @"--", @"--"];
    NSString *weatherStatusString = [NSString stringWithFormat: WEATHER_STATUS_STRING_FORMAT, @"--"];
    
    self.menu = [[NSMenu alloc] init];
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc]
                                    initWithTitle:@"Settings"
                                    action:NSSelectorFromString(openSettingsWindowSelector)
                                    keyEquivalent:@""];
    
    NSMenuItem *updateMenuItem = [[NSMenuItem alloc]
                                  initWithTitle:@"Update"
                                  action:NSSelectorFromString(executeDarkSkyRequestSelector)
                                  keyEquivalent:@""];
    
    NSMenuItem *locationMenuItem = [[NSMenuItem alloc]
                                    initWithTitle:locationString
                                    action:nil
                                    keyEquivalent:@""];
    
    NSMenuItem *weatherInfoMenuItem = [[NSMenuItem alloc]
                                       initWithTitle:weatherInfoString
                                       action:nil
                                       keyEquivalent:@""];
    
    NSMenuItem *weatherStatusMenuItem = [[NSMenuItem alloc]
                                          initWithTitle:weatherStatusString
                                          action:nil
                                          keyEquivalent:@""];
    
    [settingsMenuItem setTarget: statusBarController];
    [updateMenuItem setTarget: statusBarController];
    
    [locationMenuItem setTag:LOCATION_MENU_ITEM_TAG];
    [weatherInfoMenuItem setTag:WEATHER_INFO_MENU_ITEM_TAG];
    [weatherStatusMenuItem setTag:WEATHER_STATUS_MENU_ITEM_TAG];
    
    //add items to the menu
    [self.menu addItem:locationMenuItem];
    [self.menu addItem:weatherStatusMenuItem];
    [self.menu addItem:weatherInfoMenuItem];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItem:updateMenuItem];
    [self.menu addItem:settingsMenuItem];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItemWithTitle:@"Exit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = self.menu;
}

- (void) setMenuItemValues: (Location *) location weather: (Weather *) weather {
    NSString *locationString = [NSString
                                stringWithFormat: LOCATION_STRING_FORMAT,
                                location.city,
                                location.stateShort,
                                location.countryShort,
                                location.zipCode];
    NSMenuItem *locationMenuItem = [self.menu itemWithTag: LOCATION_MENU_ITEM_TAG];
    [locationMenuItem setTitle: locationString];
    
    NSString *weatherInfoString = [NSString
                                   stringWithFormat: WEATHER_INFO_STRING_FORMAT,
                                   weather.highTemperature,
                                   weather.lowTemperature];
    NSMenuItem *weatherInfoMenuItem = [self.menu itemWithTag: WEATHER_INFO_MENU_ITEM_TAG];
    [weatherInfoMenuItem setTitle: weatherInfoString];
    
    NSString *weatherStatusString = [NSString
                                     stringWithFormat: WEATHER_STATUS_STRING_FORMAT,
                                     weather.status];
    NSMenuItem *weatherStatusMenuItem = [self.menu itemWithTag: WEATHER_STATUS_MENU_ITEM_TAG];
    [weatherStatusMenuItem setTitle: weatherStatusString];
    
    //set temperature in menu bar
    self.statusItem.title = [NSString
                             stringWithFormat: TEMPERATURE_STRING_FORMAT,
                             [weather.currentTemperature stringValue]];
}

@end
