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
    
    
    NSPopover *popover = [[NSPopover alloc] init];
    
    
    [GoogleGeoAPIService getLocationFromZip:@"40517" completionHandler:^(Location *location){
        NSLog(@"whatup tho");
        
        if(location != nil) {
            NSLog(@"%g", location.latitude);
            NSLog(@"%g", location.longitude);
            
            //need a callback for this as well I guess
            [DarkSkyAPIService makeWeatherRequest: location completionHandler:^(NSNumber *temperature) {
                NSLog(@"handling temperature stuff now");
                NSLog(@"temperature in Lexington: %d", [temperature intValue]);
            }];
        }
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)settingsButtonClicked:(NSButton *)sender {
}
@end
