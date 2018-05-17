//
//  ServicesMapping.h
//  Yammy
//
//  Created by Alex on 25.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"

@interface ServicesMapping : NSObject

@property (strong, nonatomic) NSNumber *IdServices;
@property (strong, nonatomic) NSString *SystemCode;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSNumber *Price;
@property (strong, nonatomic) ImageMapping *Icon;
@property (strong, nonatomic) NSNumber *Enabled;
@property (strong, nonatomic) NSNumber *IsPopular;
@property (strong, nonatomic) NSString *PaidEntityType;
@property (strong, nonatomic) NSNumber *GiftId;
@property (strong, nonatomic) NSNumber *ServiceId;
@property (strong, nonatomic) NSNumber *StickerId;

+ (RKObjectMapping *)objectMapping;

@end


@interface UserServicesMapping : NSObject

@property (strong, nonatomic) NSNumber *IdUserServices;
@property (strong, nonatomic) NSNumber *UserId;
@property (strong, nonatomic) NSNumber *ServiceId;
@property (strong, nonatomic) NSNumber *DueTo;
@property (strong, nonatomic) NSNumber *CreatedOn;
@property (strong, nonatomic) ServicesMapping *Service;

+ (RKObjectMapping *)objectMapping;

@end

