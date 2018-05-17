//
//  NotificationsHelper.h
//  Yammy
//
//  Created by Paul Yevchenko on 20/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const NotificationActivityEventChated;
FOUNDATION_EXPORT NSString *const NotificationActivityEventChatStatusChangedToSeen;
FOUNDATION_EXPORT NSString *const NotificationActivityEventChatStatusChangedToDelivered;

@interface NotificationsHelper : NSObject
+ (instancetype) shared;

@property (nonatomic) NSString *deviceToken; // FCM
@property (nonatomic, readonly) BOOL isSubscribed;

- (void) checkSubscription;
- (void) appDidReceiveRemoteNotification:(NSDictionary*)data;
- (void) userDidTapRemoteNotification:(NSDictionary*)data;
@end
