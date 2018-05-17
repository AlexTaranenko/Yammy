//
//  OKHelper.h
//  Yammy
//
//  Created by Alex on 8/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ok-ios-sdk/OKSDK.h>
#import "OKUserModel.h"

// Production
//static NSString *appIdOK = @"1253554688";
//static NSString *appKeyOK = @"CBALLILLEBABABABA";

// Test
static NSString *appIdOK = @"1266484992";
static NSString *appKeyOK = @"9470152FD7FF6FFB6BA27EBD";

typedef void(^SuccessLoginToOK)(BOOL isSuccess, OKUserModel *okUserModel);

@interface OKHelper : NSObject

+ (OKHelper *)sharedOKHelper;

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void)loginToOKWithCompletion:(SuccessLoginToOK)completion;

+ (NSString *)accessOKToken;

+ (NSString *)accessOKTokenSecretKey;

@end
