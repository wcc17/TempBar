//
//  AppDelegate.m
//  Temperature
//
//  Created by Christian Curry on 9/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "AppDelegate.h"
#import "DarkSkyAPIService.h"
#import "GoogleGeoAPIService.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    // The text that will be shown in the menu bar
    _statusItem.title = @"78°";
    
    // The image gets a blue background when the item is selected
    _statusItem.highlightMode = YES;
    
    [GoogleGeoAPIService getLocationFromZip:@"40330" completionHandler:^(Location *location){
        NSLog(@"whatup tho");
        NSLog(@"%g", location.latitude);
        NSLog(@"%g", location.longitude);
    }];
    [DarkSkyAPIService makeWeatherRequest:0 :0];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)settingsButtonClicked:(NSButton *)sender {
}
@end
