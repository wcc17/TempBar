//
//  AppDelegate.m
//  Temperature
//
//  Created by Christian Curry on 9/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "AppDelegate.h"

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
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//TODO: needs to be in its own class
- (void) makeHTTPRequest:(NSString *) zipCode {
    
    /**
     *https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA
     **/
    
    //TODO: get out of here
    NSString *API_KEY = @"AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA";
    
    NSString *locationURL = @"https://maps.googleapis.com/maps/api/geocode/json?address=40330&key=";
    locationURL = [locationURL stringByAppendingString:API_KEY];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:locationURL]];
}


- (IBAction)settingsButtonClicked:(NSButton *)sender {
}
@end
