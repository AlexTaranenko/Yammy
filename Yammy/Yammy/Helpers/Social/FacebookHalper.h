//
//  FacebookHalper.h
//  Yammy
//
//  Created by Alex on 09.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FacebookUser.h"

static NSString *kFacebookAppId         = @"fb159207887963444";
static NSString *kAccessToken           = @"FBAccessToken";
static NSString *kAppID                 = @"FBAppID";
static NSString *kExpirationDate        = @"FBExpirationDate";
static NSString *kPermissions           = @"FBPermissions";
static NSString *kRefreshDate           = @"FBRefreshDate";
static NSString *kDeclinedPermissions   = @"FBDeclinedPermissions";
static NSString *kUserID                = @"FBUserID";

typedef void (^CheckForUserAndLoginBlock) (BOOL valid, FacebookUser *user);
typedef void (^FacebookLoginBlock) (BOOL success, FacebookUser *user);
typedef void (^FacebookLogoutBlock) (BOOL success);
typedef void (^ShareBlock) (BOOL success);

@interface FacebookHalper : NSObject

@property (strong, nonatomic) FacebookUser *loggedInUser;
@property (strong, nonatomic) NSMutableArray *facebookAlbums;

@property (copy, nonatomic) ShareBlock shareBlock;
@property (copy, nonatomic) CheckForUserAndLoginBlock block;

+ (FacebookHalper *)sharedFacebookHelper;

- (NSString *)urlSheme;

+ (void)clearAccessToken;

+ (FBSDKAccessToken *)accessToken;

+ (void)setAccessToken:(FBSDKAccessToken *)token;

+ (BOOL)isAuthSaved;

- (void)checkIfAlreadyLoggedInonFinished:(CheckForUserAndLoginBlock)onFinished;

- (void)loginToFacebookOnFinished:(FacebookLoginBlock)onFinished;

- (void)logoutOfFacebookOnFinished:(FacebookLogoutBlock)onFinished;

- (void)shareToYourPageWithDictionary:(NSDictionary *)dict OnFinished:(ShareBlock)onFinished;

- (void)shareContent:(id<FBSDKSharingContent>)content withMessage:(NSString *)message delegate:(id<FBSDKSharingDelegate>)delegate;

@end
