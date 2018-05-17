//
//  LoginModel.h
//  Yammy
//
//  Created by Alex on 17.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookUser.h"

@interface LoginModel : NSObject

@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *nameUser;
@property (strong, nonatomic) NSString *socialToken;
@property (strong, nonatomic) NSDate *birthdayUser;
@property (strong, nonatomic) NSNumber *sexUser;
@property (strong, nonatomic) NSString *confirmPassword;
@property (strong, nonatomic) NSString *verificationCode;
@property (strong, nonatomic) NSData *imageFileData;

- (instancetype)init;

- (void)resetValues;

- (void)setupValuesByFacebookUser:(FacebookUser *)facebookUser;

@end

