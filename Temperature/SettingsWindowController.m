//
//  SettingsWindowController.m
//  Temperature
//
//  Created by Christian Curry on 10/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "SettingsWindowController.h"
#import "StatusBarHandler.h"

@interface SettingsWindowController ()

@end

@implementation SettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"Window opened");
}

- (IBAction)onCancelClick:(NSButton *)sender {
    [self.settingsWindow close];
}

- (IBAction)onConfirmClick:(NSButton *)sender {
    
    NSString *zipCode = self.zipCodeTextField.stringValue;
    
    [[StatusBarHandler instance] setTemperatureFromLocation: zipCode];
    
    [self.settingsWindow close];
}
@end
