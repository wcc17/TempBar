//
//  StatusBarMenu.h
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

@interface StatusBarMenu : NSObject

@property (strong, nonatomic) NSMenu *menu;

#define INFO_MENU_ITEM_TAG (1)

- (void) initializeMenu: (Location *) location openSettingsWindowSelector:(NSString *) openSettingsWindowSelector executeDarkSkyRequestSelector:(NSString *) executeDarkSkyRequestSelector;
- (void) setMenuItemValues: (Location *) location temperature: (NSNumber *) temperature;

@end
