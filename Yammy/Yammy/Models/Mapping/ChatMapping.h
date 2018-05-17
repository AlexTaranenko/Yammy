//
//  ChatMapping.h
//  Yammy
//
//  Created by Alex on 11/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageMapping.h"

@interface ChatMapping : NSObject

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *SubTitle;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) NSNumber *WithUserId;
@property (strong, nonatomic) ImageMapping *OpponentUserPhoto;
@property (strong, nonatomic) NSNumber *OpponentIsOnline;
@property (strong, nonatomic) NSNumber *UnSeen;
@property (strong, nonatomic) NSNumber *ChatStatus;
@property (strong, nonatomic) NSNumber *IsBlocked;
@property (strong, nonatomic) NSNumber *IsIncoming;

+ (RKObjectMapping *)objectMapping;

@end

@interface ChatListMapping : NSObject

@property (strong, nonatomic) NSNumber *Group;
@property (strong, nonatomic) NSArray *Items;

+ (RKObjectMapping *)objectMapping;

@end
