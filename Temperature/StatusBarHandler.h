//
//  StatusBarHandler.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SettingsWindowController.h"
#import "DarkSkyAPIService.h"
#import "GoogleGeoAPIService.h"

@interface StatusBarHandler : NSObject

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) SettingsWindowController *settingsWindowController;

+ (StatusBarHandler *) instance;
- (void) openSettings;
- (void) initializeStatusMenu;
- (void) setTemperatureFromLocation: (NSString *)zipCode;

@end
