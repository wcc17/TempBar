//
//  StatusBarMenu.m
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu

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
    //TODO: placeholder text for high and low temperature. Need to make Weather object that holds a bunch of weather info I might need from DarkSky
    int highTemperature = 50;
    int lowTemperature = 30;
    
    //TODO: everlything needs a better name than just infoString1 with the number at the end.
    //TODO: Could probably use a constant for the stringWithFormat values
    NSString *infoString1 = [NSString stringWithFormat:@"%@, %@ %@ %@", location.city, location.stateShort, location.countryShort, location.zipCode];
    NSString *infoString2 = [NSString stringWithFormat:@"H: %d   L: %d", highTemperature, lowTemperature];
    
    self.menu = [[NSMenu alloc] init];
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Settings" action:NSSelectorFromString(openSettingsWindowSelector) keyEquivalent:@""];
    NSMenuItem *updateMenuItem = [[NSMenuItem alloc] initWithTitle:@"Update" action:NSSelectorFromString(executeDarkSkyRequestSelector) keyEquivalent:@""];
    NSMenuItem *infoMenuItem1 = [[NSMenuItem alloc] initWithTitle:infoString1 action:nil keyEquivalent:@""];
    NSMenuItem *infoMenuItem2 = [[NSMenuItem alloc] initWithTitle:infoString2 action:nil keyEquivalent:@""];
    
    [settingsMenuItem setTarget: statusBarController];
    [updateMenuItem setTarget: statusBarController];
    
    //adding tag to infoMenuItem so that it can be referenced easily and updated later
    //TODO: these tags need better names now
    [infoMenuItem1 setTag:INFO_MENU_ITEM_1_TAG];
    [infoMenuItem2 setTag:INFO_MENU_ITEM_2_TAG];
    
    //add items to the menu
    [self.menu addItem:infoMenuItem1];
    [self.menu addItem:infoMenuItem2];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItem:updateMenuItem];
    [self.menu addItem:settingsMenuItem];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItemWithTitle:@"Exit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = self.menu;
}

- (void) setMenuItemValues: (Location *) location temperature: (NSNumber *) temperature {
    NSString *infoString1 = [NSString stringWithFormat:@"%@, %@ %@ %@", location.city, location.stateShort, location.countryShort, location.zipCode];
    
    NSMenuItem *infoMenuItem1 = [self.menu itemWithTag: INFO_MENU_ITEM_1_TAG];
    [infoMenuItem1 setTitle: infoString1];
    
    //TODO: placeholder text for high and low temperature. Need to make Weather object that holds a bunch of weather info I might need from DarkSky
    int highTemperature = 50;
    int lowTemperature = 30;
    NSString *infoString2 = [NSString stringWithFormat:@"H: %d L: %d", highTemperature, lowTemperature];
    
    NSMenuItem *infoMenuItem2 = [self.menu itemWithTag: INFO_MENU_ITEM_2_TAG];
    [infoMenuItem2 setTitle: infoString2];
    
    self.statusItem.title = [NSString stringWithFormat:@"%@°", [temperature stringValue]];
}

@end
