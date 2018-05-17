//
//  NotificationsHelper.m
//  Yammy
//
//  Created by Paul Yevchenko on 20/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "NotificationsHelper.h"
#import "TabBarViewController.h"

NSString *const NotificationActivityEventChated = @"NotificationActivityEventChated";
NSString *const NotificationActivityEventChatStatusChangedToSeen = @"NotificationActivityEventChatStatusChangedToSeen";
NSString *const NotificationActivityEventChatStatusChangedToDelivered = @"NotificationActivityEventChatStatusChangedToDelivered";
@interface NotificationsHelper ()
@property (nonatomic, readwrite) BOOL isSubscribed;
@end

@implementation NotificationsHelper
+ (instancetype) shared
{
    static NotificationsHelper *sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

@synthesize deviceToken = _deviceToken;
@synthesize isSubscribed = _isSubscribed;

-(BOOL)isSubscribed
{
    return _isSubscribed && _deviceToken != nil;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    
    _isSubscribed = NO; // force to subscribe
    [self checkSubscription];
}

- (void) checkSubscription
{
    if(_isSubscribed)
        return;
    
    // otherwise
    if(_deviceToken != nil)
    {
        NSString *token = [Helpers getAccessToken];
        if(token != nil) // user already signed in
        {
            [[ServerManager sharedManager] subscribeNotificationsWithParams:@{
                                                                              @"Token": token,
                                                                              @"DeviceToken" : _deviceToken
                                                                              }
                                                             withCompletion:^(BOOL status, NSString *errorMessage) {
                                                                 _isSubscribed = status;
                                                             }];
        }
    }
    else
    {
        // TODO: deviceToken - error
    }
}

- (void) userDidTapRemoteNotification:(NSDictionary *)data {
    NSLog(@"%@", data);
  [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
  DELEGATE.isDidTapNotification = YES;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_PUSH object:nil userInfo:data];
  });
}

- (void) appDidReceiveRemoteNotification:(NSDictionary *)data {
  NSLog(@"%@", data);
  [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
  DELEGATE.isDidTapNotification = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_PUSH object:nil userInfo:data];
  });
}

@end
