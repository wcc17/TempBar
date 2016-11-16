//
//  Util.m
//  Temperature
//
//  Created by Christian Curry on 11/15/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (int) convertSecondsToTimeUnit:(NSString *)selectedTimeUnit :(NSString *) timeText {
    int refreshTime = [timeText intValue];
    
    //need to convert unit to seconds
    if([selectedTimeUnit isEqual:@"Minute(s)"]) {
        refreshTime *= MINUTE_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Hour(s)"]) {
        refreshTime *= HOUR_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Day(s)"]) {
        refreshTime *= DAY_IN_SECONDS;
    }
    
    NSLog(@"Refresh time: %d", refreshTime);
    
    return refreshTime;
}

+ (int) getSecondsFromTimeUnit:(NSString *)selectedTimeUnit :(int) time {
    int refreshTime = time;
    
    if([selectedTimeUnit isEqual:@"Minute(s)"]) {
        refreshTime /= MINUTE_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Hour(s)"]) {
        refreshTime /= HOUR_IN_SECONDS;
    } else if([selectedTimeUnit isEqual:@"Day(s)"]) {
        refreshTime /= DAY_IN_SECONDS;
    }
    
    NSLog(@"Refresh time: %d", refreshTime);
    
    return refreshTime;
}

@end
