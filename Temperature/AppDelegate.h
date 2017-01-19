//
//  AppDelegate.h
//  Temperature
//
//  Created by Christian Curry on 9/25/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusBarController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (void) initializeNotifications;
- (void) receiveWakeNote: (NSNotification*) note;

@end

