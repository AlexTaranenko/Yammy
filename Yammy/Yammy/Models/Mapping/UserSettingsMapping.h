//
//  UserSettingsMapping.h
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageMapping.h"

@interface UserSettingsMapping : NSObject

@property (strong, nonatomic) NSNumber *UserId;
@property (strong, nonatomic) NSNumber *AllowToShareProfile;
@property (strong, nonatomic) NSNumber *VisibleToSearchEngines;
@property (strong, nonatomic) NSNumber *NotifyOnChat;
@property (strong, nonatomic) NSNumber *NotifyOnLike;
@property (strong, nonatomic) NSNumber *NotifyOnSuperLike;
@property (strong, nonatomic) NSNumber *NotifyOnFollower;
@property (strong, nonatomic) NSNumber *Subscribed;
@property (strong, nonatomic) NSNumber *NotifyOnGift;
@property (strong, nonatomic) NSNumber *HideLinkedAccounts;
@property (strong, nonatomic) NSNumber *Hidden;
@property (strong, nonatomic) NSNumber *LanguageId;
@property (strong, nonatomic) LanguageMapping *Language;
@property (strong, nonatomic) NSNumber *TranslateChats;
@property (strong, nonatomic) NSNumber *DeleteRequested;
@property (strong, nonatomic) NSNumber *DeleteAfter;

+ (RKObjectMapping *)objectMapping;

@end

