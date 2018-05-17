//
//  MessageMapping.h
//  Yammy
//
//  Created by Alex on 11/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftMapping.h"
#import "ImageMapping.h"
#import "ProfileMapping.h"
#import "AudioMapping.h"
#import "DictionaryMapping.h"

typedef enum : NSUInteger {
  STATUS_SENDING = 0,
  STATUS_DELIVERED,
  STATUS_READ,
} StatusMessages;

static NSInteger const STATUS_FAILED = -2;
static NSInteger const STATUS_NEW = -1;

@interface MessageMapping : NSObject

@property (strong, nonatomic) NSNumber *EventStatusTyped;
@property (strong, nonatomic) NSNumber *EventTypeTyped;
@property (strong, nonatomic) NSNumber *IdMessage;
@property (strong, nonatomic) NSNumber *FromUserId;
@property (strong, nonatomic) NSNumber *ToUserId;
@property (strong, nonatomic) NSNumber *Status;
@property (strong, nonatomic) NSNumber *EventDate;
@property (strong, nonatomic) NSString *Message;
@property (strong, nonatomic) NSNumber *GiftId;
@property (strong, nonatomic) NSNumber *IsGift;
@property (strong, nonatomic) AudioMapping *Audio;
@property (strong, nonatomic) GiftMapping *Gift;
@property (strong, nonatomic) ImageMapping *Image;
@property (strong, nonatomic) ProfileMapping *ToUser;
@property (strong, nonatomic) ProfileMapping *FromUser;
@property (strong, nonatomic) NSNumber *IsAudio;
@property (strong, nonatomic) NSNumber *IsImage;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *SubTitle;
@property (strong, nonatomic) DictionaryMapping *Sticker;
@property (strong, nonatomic) NSNumber *StickerId;

+ (RKObjectMapping *)objectMapping;

@end

