//
//  StatusBarMenu.h
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

//needed in order to set the menu item's targets to the StatusBarController
@class StatusBarController;

@interface StatusBarMenu : NSObject

@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSStatusItem *statusItem;

#define INFO_MENU_ITEM_TAG (1)

- (void) initialize;

- (void) initializeMenuItems: (Location *) location
    openSettingsWindowSelector:(NSString *) openSettingsWindowSelector
    executeDarkSkyRequestSelector:(NSString *) executeDarkSkyRequestSelector
    statusBarController: (StatusBarController *) statusBarController;

- (void) setMenuItemValues: (Location *) location temperature: (NSNumber *) temperature;

@end
