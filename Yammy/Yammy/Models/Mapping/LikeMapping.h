//
//  LikeMapping.h
//  Yammy
//
//  Created by Alex on 12/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileMapping.h"

@interface LikeMapping : NSObject

@property (strong, nonatomic) NSNumber *IdLike;
@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSNumber *ToUserId;
@property (strong, nonatomic) NSNumber *Status;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) NSNumber *IsSuper;
@property (strong, nonatomic) ProfileMapping *FromUser;
@property (strong, nonatomic) NSString *SubTitle;

+ (RKObjectMapping *)objectMapping;

@end

