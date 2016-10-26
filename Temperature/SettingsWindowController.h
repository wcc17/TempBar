//
//  SettingsWindowController.h
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SettingsWindowController : NSWindowController

@property (strong) IBOutlet NSWindow *settingsWindow;

@property (weak) IBOutlet NSTextField *zipCodeTextField;

- (IBAction)onConfirmClick:(NSButton *)sender;
- (IBAction)onCancelClick:(NSButton *)sender;

@end
