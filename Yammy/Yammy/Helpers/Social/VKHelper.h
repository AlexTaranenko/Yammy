//
//  VKHelper.h
//  Yammy
//
//  Created by Alex on 15.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VK-ios-sdk/VKSdk.h>
#import "VKUserModel.h"

@protocol VKHelperDelegate <NSObject>

- (void)didVKLogin;

- (void)didVKError;

@end

@interface VKHelper : NSObject<VKSdkDelegate, VKSdkUIDelegate>

@property (assign, nonatomic) id<VKHelperDelegate> delegate;

@property (strong, nonatomic) VKUserModel *vkUserModel;

+ (VKHelper *)sharedVKHelper;

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)setupVKWithDelegate:(id<VKHelperDelegate>)delegate;

- (void)loginToVK;

+ (NSString *)authorizationToken;

+ (NSString *)secretToken;

+ (NSString *)email;

@end
