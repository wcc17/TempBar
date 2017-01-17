//
//  Weather.h
//  Temperature
//
//  Created by Christian Curry on 1/17/17.
//  Copyright © 2017 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (readwrite, nonatomic) NSNumber* currentTemperature;
@property (readwrite, nonatomic) NSNumber* highTemperature;
@property (readwrite, nonatomic) NSNumber* lowTemperature;
@property (readwrite, nonatomic) NSString* status;

@end
