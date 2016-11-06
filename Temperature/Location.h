//
//  Location.h
//  Temperature
//
//  Created by Christian Curry on 10/18/16.
//  Copyright © 2016 Christian Curry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (readwrite, nonatomic) double latitude;
@property (readwrite, nonatomic) double longitude;
@property (readwrite, nonatomic) NSString *city;
@property (readwrite, nonatomic) NSString *zipCode;
@property (readwrite, nonatomic) NSString *stateLong;
@property (readwrite, nonatomic) NSString *stateShort;
@property (readwrite, nonatomic) NSString *countryLong;
@property (readwrite, nonatomic) NSString *countryShort;

@end
