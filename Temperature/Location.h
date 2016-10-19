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

@end