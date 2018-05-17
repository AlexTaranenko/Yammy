//
//  OKHelper.m
//  Yammy
//
//  Created by Alex on 8/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "OKHelper.h"

@interface OKHelper()

@property (strong, nonatomic) OKUserModel *okUserModel;

@end

@implementation OKHelper

+ (OKHelper *)sharedOKHelper {
  static OKHelper *sharedOKHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedOKHelper = [[OKHelper alloc] init];
  });
  return sharedOKHelper;
}

- (instancetype)init {
  self = [super init];
  
  if (self) {
    [self setupOKSettings];
  }
  
  return self;
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [OKSDK openUrl:url];
}

- (void)setupOKSettings {
  OKSDKInitSettings *settings = [OKSDKInitSettings new];
  settings.appId = appIdOK;
  settings.appKey = appKeyOK;
  settings.controllerHandler = ^UIViewController *{
    return DELEGATE.window.rootViewController;
  };
  
  [OKSDK initWithSettings:settings];
}

- (void)loginToOKWithCompletion:(SuccessLoginToOK)completion {
  [OKSDK authorizeWithPermissions:@[@"VALUABLE_ACCESS", @"LONG_ACCESS_TOKEN", @"GET_EMAIL"] success:^(id data) {
    if (data) {
      NSArray *dataArray = (NSArray *)data;
      NSString *accessOKToken = [dataArray firstObject];
      NSString *accessOKTokenSecretKey = [dataArray lastObject];
      [self setAccessOKToken:accessOKToken andAccessOKTokenSecretKey:accessOKTokenSecretKey];
    }
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{} success:^(id data) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (data) {
          NSDictionary *dictionary = (NSDictionary *)data;
          self.okUserModel = [[OKUserModel alloc] initWithDictionary:dictionary];
        }
        
        completion(YES, self.okUserModel);
      });
    } error:^(NSError *error) {
      NSLog(@"%@", error.localizedDescription);
      completion(NO, nil);
    }];
  } error:^(NSError *error) {
    NSLog(@"%@", error.localizedDescription);
    completion(NO, nil);
  }];
}

- (void)setAccessOKToken:(NSString *)accessOKToken andAccessOKTokenSecretKey:(NSString *)accessOKTokenSecretKey {
  [[NSUserDefaults standardUserDefaults] setObject:accessOKToken forKey:@"OKAccessToken"];
  [[NSUserDefaults standardUserDefaults] setObject:accessOKTokenSecretKey forKey:@"OKAccessTokenSecretKey"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)accessOKToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"OKAccessToken"];
}

+ (NSString *)accessOKTokenSecretKey {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"OKAccessTokenSecretKey"];
}

@end
