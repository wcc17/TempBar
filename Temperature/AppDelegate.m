//
//  AppDelegate.m
//  Temperature
//
//  Created by Christian Curry on 9/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    //set default value to one of Lexington, KY zip codes in case a zip code hasn't been saved
    NSDictionary *userDefaultsDefaults = @{ @"zipCode": @"40517",
                                            @"city": @"Lexington",
                                            @"stateLong": @"Kentucky",
                                            @"stateShort": @"KY",
                                            @"countryLong": @"United States",
                                            @"countryShort": @"US",
                                            @"refreshTimeInterval": @3600,
                                            @"refreshTimeUnit": @"Hour(s)" };
    [NSUserDefaults.standardUserDefaults registerDefaults:userDefaultsDefaults];
    
    //Initialize the status menu object
    [self initializeStatusMenu];
    
    //Sets up application to be notified when computer is put to sleep or woken up
    [self initializeNotifications];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[StatusBarController instance] tearDown];
}

- (void)initializeStatusMenu {
    [[StatusBarController instance] initialize];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    NSLog(@"receiveWakeNote: %@", [note name]);
    [[StatusBarController instance] handleWakeNotification];
}

- (void) initializeNotifications {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
}

@end
