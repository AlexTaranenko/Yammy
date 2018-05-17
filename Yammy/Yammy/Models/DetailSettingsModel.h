//
//  DetailSettingsModel.h
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
  VisibleToSearchEngines = 0,
  AllowToShareProfile,
  NotifyOnChat,
  NotifyOnLike,
  NotifyOnSuperLike,
  NotifyOnFollower,
  Subscribed,
  NotifyOnGift,
  HideLinkedAccounts,
  Hidden,
  OffAll = 20
} DetailSettingsType;

@interface DetailSettingsModel : NSObject

@property (strong, nonatomic) NSString *titleDetailSettings;
@property (strong, nonatomic) NSString *descriptionDetailSettings;
@property (assign, nonatomic) BOOL isOnDetailSettings;
@property (assign, nonatomic) DetailSettingsType type;

- (instancetype)initWithTitle:(NSString *)title withDescription:(NSString *)description andIsOn:(BOOL)isOn andType:(DetailSettingsType)type;

@end
