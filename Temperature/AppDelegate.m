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
    
    [self makeLocationRequest:nil];
    [self makeWeatherRequest:0 :0];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//TODO: needs to be in its own class
- (void) makeLocationRequest:(NSString *) zipCode {
    
    /**
     *https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA
     **/
    
    //TODO: get out of here
    NSString *GOOGLE_API_KEY = @"AIzaSyC4aNXiL4hsMKhVI2xmSljOj1M1_Q1DvvA";
    NSString *locationURL = @"https://maps.googleapis.com/maps/api/geocode/json?address=40330&key=";
    
    locationURL = [locationURL stringByAppendingString:GOOGLE_API_KEY];
    NSURL *requestURL = [NSURL URLWithString:locationURL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        [self handleLocationResponse:data];
    }] resume];
}

- (void) handleLocationResponse:(NSData *)data {
    //handle response
    NSLog(@"handling response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void) makeWeatherRequest:(double) latitude :(double) longitude {
    //https://api.darksky.net/forecast/fb30f9d966ec63fc374f93f2b5816b94/37.8267,-122.4233
    
    //TODO: remove
    latitude = 37.8267;
    longitude = -122.4233;
    
    //TODO: get out of here
    NSString *DARKSKY_API_KEY = @"fb30f9d966ec63fc374f93f2b5816b94";
    
    NSString *darkSkyURL = @"https://api.darksky.net/forecast";
    
    NSString *weatherURLString = [NSString stringWithFormat:@"%@/%@/%@,%@",
                                  darkSkyURL,
                                  DARKSKY_API_KEY,
                                  [NSString stringWithFormat:@"%lf", latitude],
                                  [NSString stringWithFormat:@"%lf", longitude]];
    
    NSURL *requestURL = [NSURL URLWithString:weatherURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:requestURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //TODO: HANDLE ERRORS
        //TODO: anything useful in response that isnt in data?
        [self handleWeatherResponse:data];
    }] resume];
    
}

- (void) handleWeatherResponse:(NSData *) data {
    NSLog(@"handling weather response");
    
    NSString *test = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    NSLog(test);
}

- (IBAction)settingsButtonClicked:(NSButton *)sender {
}
@end
