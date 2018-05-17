//
//  LocationManager.h
//  Yammy
//
//  Created by Alex on 01.12.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocation *location;

+ (LocationManager *)sharedManager;

- (void)setupLocation;

@end

