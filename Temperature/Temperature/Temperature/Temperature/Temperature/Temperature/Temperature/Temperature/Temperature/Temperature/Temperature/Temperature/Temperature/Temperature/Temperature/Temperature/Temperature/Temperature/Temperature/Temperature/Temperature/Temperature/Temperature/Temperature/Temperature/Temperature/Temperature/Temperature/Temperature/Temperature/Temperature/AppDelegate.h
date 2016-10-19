//
//  AppDelegate.h
//  Temperature
//
//  Created by Christian Curry on 9/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak) IBOutlet NSButton *settingsButton;
@property (weak) IBOutlet NSTextField *temperatureLabel;

- (IBAction)settingsButtonClicked:(NSButton *)sender;
@end

