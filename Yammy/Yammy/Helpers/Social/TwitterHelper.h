//
//  TwitterHelper.h
//  Yammy
//
//  Created by Alex on 10.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter/STTwitter.h>
#import "TwitterUser.h"

#define kTwitterConsumerKey @"N5EAdVdM3UFEh4NLi3CWfw7Mi"
#define kTwitterConsumerSecret @"zPEuYUb8vsYV2vubbtik2OBkZUhgVaRXSLvBicVVtiYvMgGiBL"

typedef void (^CheckForTwitterUserAndLoginBlock) (BOOL success, TwitterUser *user);
typedef void (^TwitterLoginBlock) (BOOL success, TwitterUser *user);
typedef void (^TwitterLogoutBlock) (BOOL success);

@interface TwitterHelper : NSObject<STTwitterAPIOSProtocol>

@property (strong, nonatomic) STTwitterAPI *twitter;

+ (TwitterHelper *)sharedTwitterHelper;

- (void)checkIfAlreadyLoggedInonFinished:(CheckForTwitterUserAndLoginBlock)onFinished;

- (void)loginToTwitterOnFinished:(TwitterLoginBlock)onFinished;

- (void)logoutOfTwitterOnFinished:(TwitterLogoutBlock)onFinished;

+ (BOOL)isAuthSaved;

+ (NSString *)authToken;

+ (NSString *)authSecret;

+ (NSString *)uid;

+ (void)setAuthToken:(NSString*)token authSecret:(NSString*)secret uid:(NSString*)uid;

@end
