//
//  StatusBarMenu.h
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"
#import "Weather.h"
#import "Util.h"

#define LOCATION_MENU_ITEM_TAG (1)
#define WEATHER_INFO_MENU_ITEM_TAG (2)
#define WEATHER_STATUS_MENU_ITEM_TAG (3)

//needed in order to set the menu item's targets to the StatusBarController
@class StatusBarController;

@interface StatusBarMenu : NSObject

@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSStatusItem *statusItem;

extern NSString *const LOCATION_STRING_FORMAT;
extern NSString *const WEATHER_INFO_STRING_FORMAT;
extern NSString *const WEATHER_STATUS_STRING_FORMAT;
extern NSString *const TEMPERATURE_STRING_FORMAT;

- (void) initialize;

- (void) initializeMenuItems: (Location *) location
    openSettingsWindowSelector:(NSString *) openSettingsWindowSelector
    executeDarkSkyRequestSelector:(NSString *) executeDarkSkyRequestSelector
    statusBarController: (StatusBarController *) statusBarController;

- (void) setMenuItemValues: (Location *) location weather: (Weather *) weather;

@end
