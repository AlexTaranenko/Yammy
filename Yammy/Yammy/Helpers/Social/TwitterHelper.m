//
//  TwitterHelper.m
//  Yammy
//
//  Created by Alex on 10.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TwitterHelper.h"

@implementation TwitterHelper

+ (TwitterHelper *)sharedTwitterHelper {
  static TwitterHelper * sharedTwitterHelper = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedTwitterHelper = [[TwitterHelper alloc] init];
  });
  return sharedTwitterHelper;
}

- (instancetype)init {
  self = [super init];
  
  if (self) {
    [self refreshTwitter];
  }
  
  return self;
}

- (void)refreshTwitter {
  NSLog(@"refreshTwitter");
  
  NSString *oAuthToken = [[self class] authToken];
  NSString *oAuthTokenSecret = [[self class] authSecret];
  
  [self setTwitter:nil];
  
  if (!oAuthToken || !oAuthTokenSecret) {
    NSLog(@"twitter alloc WITHOUT oAuthToken");
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
  } else {
    NSLog(@"twitter alloc WITH oAuthToken");
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret oauthToken:oAuthToken oauthTokenSecret:oAuthTokenSecret];
  }
  
  NSLog(@"Setup finished");
}

+ (void)setAuthToken:(NSString *)token authSecret:(NSString *)secret uid:(NSString *)uid {
  [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"TwitterOAuthToken"];
  [[NSUserDefaults standardUserDefaults] setObject:secret forKey:@"TwitterOAuthTokenSecret"];
  [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"TwitterUserID"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)authToken {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterOAuthToken"];
}

+ (NSString *)authSecret {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterOAuthTokenSecret"];
}

+ (NSString *)uid {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterUserID"];
}

+ (BOOL)isAuthSaved {
  NSString *authToken = [[self class] authToken];
  NSString *authSecret = [[self class] authSecret];
  NSString *uid = [[self class] uid];
  
  return authToken != nil && authSecret != nil && uid != nil;
}

#pragma mark - Login

- (void)checkIfAlreadyLoggedInonFinished:(CheckForTwitterUserAndLoginBlock)onFinished {
  NSString *authToken = [[self class] authToken];
  NSString *authSecret = [[self class] authSecret];

  if (authToken && authSecret) {
    NSLog(@"Van Token & Secret");
    
    NSString *uid = [[self class] uid];
    [self.twitter getUsersShowForUserID:uid orScreenName:nil includeEntities:[NSNumber numberWithBool:NO] successBlock:^(NSDictionary *user) {
      
      TwitterUser *loggedInUser = [[TwitterUser alloc] initWithDictionary:user];
      NSLog(@"TWITTER USER ID - %@", loggedInUser.userID);
      onFinished(YES, loggedInUser);
      
    } errorBlock:^(NSError *error) {
      NSLog(@"Error block - %@", error.localizedDescription);
      [self logoutOfTwitterOnFinished:^(BOOL success) {
        onFinished(NO, nil);
      }];
    }];
  } else {
    NSLog(@"Nincs Token, se Secret");
    onFinished(NO, nil);
  }
}

- (void)loginToTwitterOnFinished:(TwitterLoginBlock)onFinished {
  NSLog(@"loginToTwitter");
  [self refreshTwitter];

  NSLog(@"startPostReverse");
  [self.twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
    NSLog(@"authenticationHeader - %@", authenticationHeader);
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccountAndDelegate:self];
    
    NSLog(@"twitter - %@", self.twitter);
    
    [self.twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
      NSLog(@"verifyCredentials - %@", username);
      
      [self.twitter postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader successBlock:^(NSString *oAuthToken, NSString *oAuthTokenSecret, NSString *userID, NSString *screenName) {
        
        NSLog(@"OAUTHTOKEN - %@", oAuthToken);
        NSLog(@"USERID - %@", userID);
        NSLog(@"oAuthTokenSecret - %@", oAuthTokenSecret);
        NSLog(@"SCREENNAME - %@", screenName);
        
        [[self class] setAuthToken:oAuthToken authSecret:oAuthTokenSecret uid:userID];
        NSLog(@"TWITTER USER ID - %@", userID);
        
        [self.twitter getUsersShowForUserID:userID orScreenName:nil includeEntities:[NSNumber numberWithBool:NO] successBlock:^(NSDictionary *user) {
          
          NSLog(@"TWITTER USER - %@", user);
          TwitterUser *loggedInUser = [[TwitterUser alloc] initWithDictionary:user];
          loggedInUser.userID = userID;
          
          // Login Process
          onFinished(YES, loggedInUser);
          
        } errorBlock:^(NSError *error) {
          NSLog(@"TWITTER GET USER Error block - %@", error.localizedDescription);
          onFinished(YES, nil);

        }];
      } errorBlock:^(NSError *error) {
        
        NSLog(@"twitter authentication failed");
        NSLog(@"error postreverse - %@", error.localizedDescription);
        
      }];
    } errorBlock:^(NSError *error) {
      
      NSLog(@"error verify - %@", error.localizedDescription);
      [UIAlertHelper alert:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings." title:@"No Twitter Accounts" cancelButton:@"Cancel" successButton:@"Settings" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction) {
        if (successAction) {
          NSURL *url = [NSURL URLWithString:@"App-Prefs:root=TWITTER"];
          if (url) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
              [[UIApplication sharedApplication] openURL:url];
            }
          } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
          }
        }
      }];
      onFinished(NO, nil);
      
    }];
    
  } errorBlock:^(NSError *error) {
    NSLog(@"error twitter postreverse");
  }];
}

- (void)logoutOfTwitterOnFinished:(TwitterLogoutBlock)onFinished {
  [[self class] setAuthToken:nil authSecret:nil uid:nil];
  [self refreshTwitter];
  onFinished(YES);
}

#pragma mark - Delegate

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
  
}

@end
