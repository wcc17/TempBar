//
//  Util.h
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

#define MINUTE_IN_SECONDS (60)
#define HOUR_IN_SECONDS (3600)
#define DAY_IN_SECONDS (86400)

+ (int)convertSecondsToTimeUnit: (NSString*)selectedTimeUnit :(NSString*) timeText;
+ (int)getSecondsFromTimeUnit:(NSString *)selectedTimeUnit :(int) time;

@end
