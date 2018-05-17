//
//  GooglePlusHelper.h
//  Yammy
//
//  Created by Alex on 12.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>
#import "GooglePlusUser.h"

@protocol GooglePlusHelperDelegate <NSObject>

- (void)didGooglePlusLogin;
- (void)didGooglePlusLogout;
- (void)didGooglePlusDisconnect;
- (void)didGooglePlusFailWithError:(NSError*)error;

@end

@interface GooglePlusHelper : NSObject<GIDSignInUIDelegate, GIDSignInDelegate>

@property (assign, nonatomic) id<GooglePlusHelperDelegate> delegate;

@property (strong, nonatomic) GooglePlusUser *loggedUser;

+ (GooglePlusHelper *)sharedGooglePlusHelper;

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)tryLoginWith:(id<GooglePlusHelperDelegate>)delegate;

- (void)tryLogout;

@end
