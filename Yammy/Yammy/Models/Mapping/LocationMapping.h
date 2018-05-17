//
//  LocationMapping.h
//  Yammy
//
//  Created by Alex on 12/15/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationMapping : NSObject

@property (strong, nonatomic) NSNumber *IdLocation;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSNumber *ParentLocationId;
@property (strong, nonatomic) NSNumber *Latitude;
@property (strong, nonatomic) NSNumber *Longitude;
//@property (strong, nonatomic) NSArray *Locations;

+ (RKObjectMapping *)objectMapping;

@end


// Parent

@interface CountryMapping : NSObject

@property (strong, nonatomic) NSNumber *IdLocation;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSNumber *ParentLocationId;
@property (strong, nonatomic) NSNumber *Latitude;
@property (strong, nonatomic) NSNumber *Longitude;
@property (strong, nonatomic) NSArray *Locations;

+ (RKObjectMapping *)objectMapping;

@end

