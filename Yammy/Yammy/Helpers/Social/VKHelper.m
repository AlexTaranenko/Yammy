//
//  VKHelper.m
//  Yammy
//
//  Created by Alex on 15.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "VKHelper.h"

static NSString *appIdVK = @"6336661";
//static NSString *appIdVK = @"3974615";

static NSArray *SCOPE = nil;

static NSString *const ALL_USER_FIELDS = @"id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,online_mobile,lists,domain,has_mobile,contacts,connections,site,education,universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,status,last_seen,common_count,relation,relatives,counters";

@interface VKHelper()

@end

@implementation VKHelper

+ (VKHelper *)sharedVKHelper {
  static VKHelper *sharedVKHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedVKHelper = [[VKHelper alloc] init];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
  });
  return sharedVKHelper;
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [VKSdk processOpenURL:url fromApplication:annotation];
}

- (void)setupVKWithDelegate:(id<VKHelperDelegate>)delegate {
  self.delegate = delegate;
  
  [[VKSdk initializeWithAppId:appIdVK] registerDelegate:self];
  [[VKSdk instance] setUiDelegate:self];
}

- (void)getUserDataFromVK {
  [Helpers showSpinner];
  [[[VKApi users] get:@{ VK_API_FIELDS : ALL_USER_FIELDS }] executeWithResultBlock:^(VKResponse *response) {
    [Helpers hideSpinner];
    if (response) {
      NSLog(@"%@", response.json);
      NSDictionary *dictionary = (NSDictionary *)[response.json firstObject];
      self.vkUserModel = [[VKUserModel alloc] initWithDictionary:dictionary];
      [self.delegate didVKLogin];
    }
  } errorBlock:^(NSError *error) {
    [Helpers hideSpinner];
    [self.delegate didVKError];
  }];
}

- (void)loginToVK {
  [Helpers showSpinner];
  [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
    [Helpers hideSpinner];
    if (state == VKAuthorizationAuthorized) {
      [self getUserDataFromVK];
    } else if (error) {
      NSLog(@"%@", [error description]);
      [WToast showWithText:[error description]];
    } else {
      if ([VKSdk vkAppMayExists]) {
        [VKSdk authorize:SCOPE];
      } else {
        [VKSdk authorize:SCOPE withOptions:VKAuthorizationOptionsUnlimitedToken];
      }
    }
  }];
}

- (void)setAuthorizationToken:(NSString *)token andSecretToken:(NSString *)secret andEmail:(NSString *)email {
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"VKAuthorizationToken"];
  [[NSUserDefaults standardUserDefaults] setObject:secret forKey:@"VKSecretToken"];
  if (email) {
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"VKEmail"];
  }
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)authorizationToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAuthorizationToken"];
}

+ (NSString *)secretToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"VKSecretToken"];
}

+ (NSString *)email {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"VKEmail"];
}

#pragma mark - VKSdkDelegate

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
  if (result.token) {
    [self setAuthorizationToken:result.token.accessToken andSecretToken:result.token.secret andEmail:result.token.email];
    [self getUserDataFromVK];
  } else if (result.error) {
    [UIAlertHelper alert:[result.error localizedDescription] title:@"Access denied"];
  }
}

- (void)vkSdkUserAuthorizationFailed {
  NSLog(@"Access denied");
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
  [VKSdk authorize:@[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES]];
}

#pragma mark - VKSdkUIDelegate

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
  [DELEGATE.window.rootViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
  VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
  [vc presentIn:DELEGATE.window.rootViewController];
}

@end

