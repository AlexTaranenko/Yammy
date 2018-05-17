//
//  FacebookHalper.m
//  Yammy
//
//  Created by Alex on 09.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "FacebookHalper.h"

@interface FacebookHalper()<FBSDKSharingDelegate>

@property (nonatomic, getter=isLoggedIn) BOOL loggedIn;

@end

@implementation FacebookHalper

#pragma mark - Initialization

+ (FacebookHalper *)sharedFacebookHelper {
  static FacebookHalper *sharedFacebookHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedFacebookHelper = [FacebookHalper new];
  });
  return sharedFacebookHelper;
}

- (NSString *)urlSheme {
  return [NSString stringWithFormat:@"%@", kFacebookAppId];
}

#pragma mark - Auth Handling

+ (void)setAccessToken:(FBSDKAccessToken *)token {
  if (!token) {
    [FacebookHalper clearAccessToken];
    return;
  }
  
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  [userDefaults setObject:token.tokenString forKey:kAccessToken];
  
  [userDefaults setObject:token.expirationDate forKey:kExpirationDate];
  
  [userDefaults setObject:token.appID forKey:kAppID];
  
  [userDefaults setObject:[token.declinedPermissions allObjects] forKey:kDeclinedPermissions];
  
  [userDefaults setObject:[token.permissions allObjects] forKey:kPermissions];
  
  [userDefaults setObject:token.refreshDate forKey:kRefreshDate];
  
  [userDefaults setObject:token.userID forKey:kUserID];
  
  [userDefaults synchronize];
}

+ (void)clearAccessToken {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  [userDefaults setObject:nil forKey:kAccessToken];
  
  [userDefaults setObject:nil forKey:kExpirationDate];
  
  [userDefaults synchronize];
}

+ (FBSDKAccessToken *)accessToken {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  
  return [[FBSDKAccessToken alloc]
          initWithTokenString:[userDefaults objectForKey:kAccessToken]
          permissions:[userDefaults objectForKey:kPermissions]
          declinedPermissions:[userDefaults objectForKey:kDeclinedPermissions]
          appID:[userDefaults objectForKey:kAppID]
          userID:[userDefaults objectForKey:kUserID]
          expirationDate:[userDefaults objectForKey:kExpirationDate]
          refreshDate:[userDefaults objectForKey:kRefreshDate]];
}

+ (BOOL)isAuthSaved {
  return [FacebookHalper accessToken].tokenString != nil;
}

#pragma mark - Login

- (void)checkIfAlreadyLoggedInonFinished:(CheckForUserAndLoginBlock)onFinished {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  
  FBSDKAccessToken *token = [FacebookHalper accessToken];
  NSLog(@"Access Token: %@", token.tokenString);
  if (!token.tokenString) {
    onFinished(NO, nil);
    return;
  }
  
  [FBSDKAccessToken setCurrentAccessToken:token];
  
  // Check token validity
  if ([token.expirationDate compare:[NSDate date]] == NSOrderedDescending) {
    self.loggedIn = YES;
    [self fetchFacebookUserWithCompletionHandler:^(BOOL success, FacebookUser *user) {
      onFinished(success, user);
    }];
  } else {
    NSLog(@"Access Token has been expired");
    [self loginToFacebookOnFinished:^(BOOL success, FacebookUser *user) {
      onFinished(success, user);
    }];
  }
}

- (void)loginToFacebookOnFinished:(FacebookLoginBlock)onFinished {
  NSArray *permissions =  @[@"public_profile", @"email"];
  
  [Helpers hideSpinner];
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login logInWithReadPermissions:permissions fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error) {
      [WToast showWithText:@"Could not login to facebook. Please, try again."];
      onFinished(NO, nil);
    } else if (result.isCancelled) {
      
      // Handle result cancellations
      NSLog(@"Facebook login is cancelled");
      onFinished(NO, nil);
    } else {
      
      // If you ask for multiple permissions at once, you
      // should check if specific permissions missing
      if ([result.grantedPermissions containsObject:@"public_profile"]) {
        [FacebookHalper setAccessToken:result.token];
        [self fetchFacebookUserWithCompletionHandler:^(BOOL success, FacebookUser *user) {
          onFinished(success, user);
        }];
      }
    }
  }];
}

- (void)fetchFacebookUserWithCompletionHandler:(FacebookLoginBlock)completionHandler {
  NSDictionary *parameters = @{@"fields" : @"name, id, email, hometown, work, education, birthday, gender, first_name, last_name"};
  
  // Fetch user info from Facebook
  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      self.loggedInUser = [[FacebookUser alloc] initWithDictionary:(NSDictionary *)result];
      completionHandler(YES, self.loggedInUser);
    } else {
      NSLog(@"Facebook Helper Error %@", [error localizedDescription]);
      completionHandler(NO, nil);
    }
  }];
}

- (void)logoutOfFacebookOnFinished:(FacebookLogoutBlock)onFinished {
  [FacebookHalper clearAccessToken];
  self.loggedIn = NO;
  onFinished(YES);
}

- (void)shareToYourPageWithDictionary:(NSDictionary *)dict OnFinished:(ShareBlock)onFinished {
  NSLog(@"%@", NSStringFromSelector(_cmd));
  self.shareBlock = onFinished;
  
  FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
  content.contentURL = [NSURL URLWithString:@"test"];
  
  [FBSDKShareDialog showFromViewController:nil withContent:content delegate:self];
}

- (void)shareContent:(id<FBSDKSharingContent>)content withMessage:(NSString *)message delegate:(id<FBSDKSharingDelegate>)delegate {
  FBSDKShareAPI *share = [[FBSDKShareAPI alloc] init];
  share.delegate = delegate;
  share.shareContent = content;
  share.message = message;
  [share share];
}

#pragma mark - FB SDK Sharing Delegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results
{
  if (self.shareBlock) {
    self.shareBlock((BOOL)[results valueForKey:@"postId"]);
    
    self.shareBlock = nil;
  }
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error
{
  if (self.shareBlock) {
    self.shareBlock(NO);
    self.shareBlock = nil;
  }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer
{
  if (self.shareBlock) {
    self.shareBlock(NO);
    self.shareBlock = nil;
  }
}

@end

