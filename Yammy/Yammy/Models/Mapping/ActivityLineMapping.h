//
//  ActivityLineMapping.h
//  Yammy
//
//  Created by Alex on 12/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileMapping.h"

typedef enum : NSUInteger {
  UnknownType = 0,
  ProfileChanged,
  ProfileNewPhoto,
  
  OpenedPrivateProfile,
  OpenedPrivateProfileForGift,
  RequestedPrivateProfile,
  RequestedPrivateProfileForGift,
  
  VisitedProfile,
  InvisibleVisitedProfile,
  
  Chated,
  /* not used */
  ChatStatusChanged,
  Gifted,
  
  Match,
  MatchByPrivatePreferences,
  
  Liked,
  SuperLiked,
  /* not used */
  VipSuperLiked,
  
  ChatStatusChangedToDelivered,
  ChatStatusChangedToSeen,
  
  RejectedAccessToPrivateProfile,
  RejectedAccessForGiftToPrivateProfile,
  RequestedExchangePrivateProfile,
  RejectedExchangePrivateProfile,
  
  AcceptedExchangePrivateProfile,
  
  RejectedAccessButGift
} ActivityLineEventTypes;



@interface ActivityLineMapping : NSObject

@property (strong, nonatomic) NSNumber *IdActivityLine;
@property (strong, nonatomic) NSNumber *EventType;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *SubTitle;
@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSString *MediaUrl;
@property (strong, nonatomic) ProfileMapping *FromUser;
@property (strong, nonatomic) GiftMapping *Gift;
@property (strong, nonatomic) MatchMapping *Match;
@property (strong, nonatomic) NSString *Ids;
@property (strong, nonatomic) NSString *Description;

+ (RKObjectMapping *)objectMapping;

@end


// Activity Lines

@interface ActivityLinesMapping : NSObject

@property (strong, nonatomic) NSNumber *Group;
@property (strong, nonatomic) NSArray *Items;

+ (RKObjectMapping *)objectMapping;

@end

