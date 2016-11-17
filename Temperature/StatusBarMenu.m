//
//  StatusBarMenu.m
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "StatusBarMenu.h"

@implementation StatusBarMenu

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
    NSString *infoString = [NSString stringWithFormat:@"%@, %@ %@ %@", location.city, location.stateShort, location.countryShort, location.zipCode];
    
    self.menu = [[NSMenu alloc] init];
    NSMenuItem *settingsMenuItem = [[NSMenuItem alloc] initWithTitle:@"Settings" action:NSSelectorFromString(openSettingsWindowSelector) keyEquivalent:@""];
    NSMenuItem *updateMenuItem = [[NSMenuItem alloc] initWithTitle:@"Update" action:NSSelectorFromString(executeDarkSkyRequestSelector) keyEquivalent:@""];
    NSMenuItem *infoMenuItem = [[NSMenuItem alloc] initWithTitle:infoString action:nil keyEquivalent:@""];
    
    [settingsMenuItem setTarget: statusBarController];
    [updateMenuItem setTarget: statusBarController];
    
    //adding tag to infoMenuItem so that it can be referenced easily and updated later
    [infoMenuItem setTag:INFO_MENU_ITEM_TAG];
    
    //add items to the menu
    [self.menu addItem:infoMenuItem];
    [self.menu addItem:updateMenuItem];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItem:settingsMenuItem];
    [self.menu addItem:[NSMenuItem separatorItem]]; // A thin grey line
    [self.menu addItemWithTitle:@"Exit" action:@selector(terminate:) keyEquivalent:@""];
    
    self.statusItem.menu = self.menu;
}

- (void) setMenuItemValues: (Location *) location temperature: (NSNumber *) temperature {
    NSString *infoString = [NSString stringWithFormat:@"%@, %@ %@ %@", location.city, location.stateShort, location.countryShort, location.zipCode];
    
    NSMenuItem *infoMenuItem = [self.menu itemWithTag: INFO_MENU_ITEM_TAG];
    [infoMenuItem setTitle: infoString];
    
    self.statusItem.title = [NSString stringWithFormat:@"%@°", [temperature stringValue]];
}

@end
