//
//  GooglePlusHelper.m
//  Yammy
//
//  Created by Alex on 12.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GooglePlusHelper.h"

@implementation GooglePlusHelper

+ (GooglePlusHelper *)sharedGooglePlusHelper {
  static GooglePlusHelper *sharedGooglePlusHelper = nil;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    sharedGooglePlusHelper = [GooglePlusHelper new];
  });
  
  return sharedGooglePlusHelper;
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}


- (void)tryLoginWith:(id<GooglePlusHelperDelegate>)delegate {
  
  [Helpers showSpinner];
  self.delegate = delegate;
  
  NSError *configureError;
  [[GGLContext sharedInstance] configureWithError:&configureError];
  if (configureError != nil) {
    NSLog(@"Error configuring the Google context: %@", configureError);
  }
  
  [GIDSignIn sharedInstance].uiDelegate = self;
  [GIDSignIn sharedInstance].delegate = self;
  [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/plus.me",@"https://www.googleapis.com/auth/plus.stream.read"];
  
  if ([[GIDSignIn sharedInstance] hasAuthInKeychain]) {
    [[GIDSignIn sharedInstance] signInSilently];
  } else {
    [[GIDSignIn sharedInstance] signIn];
  }
}

- (void)tryLogout {
  [Helpers hideSpinner];
  [[GIDSignIn sharedInstance] disconnect];
}

#pragma mark - Delegate

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
  NSLog(@"didDisconnectWithUser");
  
  if (self.delegate != nil) {
    [self.delegate didGooglePlusDisconnect];
  }
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
  if ([GIDSignIn sharedInstance].currentUser.authentication == nil) {
    [Helpers hideSpinner];
    if (self.delegate != nil) {
      [self.delegate didGooglePlusLogout];
    }
  } else {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Perform any operations on signed in user here.
    NSLog(@"name=%@", user.profile.name);
    NSLog(@"accessToken=%@", user.authentication.accessToken);
    
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
      NSString *gplusapi = [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v3/userinfo?access_token=%@", user.authentication.accessToken];
      NSURL *url = [NSURL URLWithString:gplusapi];
      
      NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
      urlRequest.HTTPMethod = @"GET";
      [urlRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
      
      NSURLSession *urlSession = [NSURLSession sharedSession];
      [[urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSError *err = nil;
        NSDictionary *userData = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:&err];
        
        if (!userData) {
          NSLog(@"Error parsing JSON: %@", err);
          if (self.delegate != nil) {
            [self.delegate didGooglePlusFailWithError:err];
          }
        } else {
          NSString *picture = userData[@"picture"];
          NSString *gender = userData[@"gender"];
          
          GooglePlusUser *infoGooglePlusUser = [[GooglePlusUser alloc] init];
          infoGooglePlusUser.user = user;
          infoGooglePlusUser.picture = picture;
          infoGooglePlusUser.gender = gender;
          [[GooglePlusHelper sharedGooglePlusHelper] setLoggedUser:infoGooglePlusUser];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate != nil) {
              [self.delegate didGooglePlusLogin];
            }
          });
        }
      }] resume];
    }];
    [queue addOperation:blockOperation];
  }
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
  
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
//  UIViewController *vc = (UIViewController*)self.delegate;
  [Helpers hideSpinner];
  [DELEGATE.window.rootViewController presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
//  UIViewController *vc = (UIViewController*)self.delegate;
  [Helpers showSpinner];
  [DELEGATE.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
