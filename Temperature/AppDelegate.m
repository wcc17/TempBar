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
    NSDictionary *userDefaultsDefaults = @{ @"zipCode": @"40517", @"refreshTimeInterval": @3600, @"refreshTimeUnit": @"Hour(s)" };
    [NSUserDefaults.standardUserDefaults registerDefaults:userDefaultsDefaults];
    
    //Initialize the status menu object
    [self initializeStatusMenu];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [[StatusBarHandler instance] tearDown];
}

- (void)initializeStatusMenu {
    [[StatusBarHandler instance] initialize];
}

@end
