//
//  GiftMapping.h
//  Yammy
//
//  Created by Alex on 10/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageMapping.h"
#import "ProfileMapping.h"

@interface GiftMapping : NSObject

@property (strong, nonatomic) NSNumber *IdGift;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSNumber *Price;
@property (strong, nonatomic) ImageMapping *Image;
@property (strong, nonatomic) NSString *GiftType;
@property (strong, nonatomic) NSNumber *Type;

+ (RKObjectMapping *)objectMapping;

@end


// User gift mapping

@interface UserGiftMapping : NSObject

@property (strong, nonatomic) NSNumber *IdUserGift;
@property (strong, nonatomic) NSNumber *ToUserId;
@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSNumber *GiftId;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) NSNumber *Status;
@property (strong, nonatomic) NSNumber *EventStatusTyped;
@property (strong, nonatomic) NSNumber *EventTypeTyped;
@property (strong, nonatomic) GiftMapping *Gift;

+ (RKObjectMapping *)objectMapping;

@end


@interface MyGiftMapping : NSObject

@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) GiftMapping *Gift;
@property (strong, nonatomic) ProfileMapping *FromUser;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *SubTitle;

+ (RKObjectMapping *)objectMapping;

@end

