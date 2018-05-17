//
//  RegisterModel.h
//  Yammy
//
//  Created by Alex on 8/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"

@interface RegisterModel : NSObject

@property (strong, nonatomic) NSString *typeUser;
@property (strong, nonatomic) NSString *nameUser;
@property (strong, nonatomic) NSDate *birthdayUser;
@property (strong, nonatomic) NSNumber *sexUser;
@property (strong, nonatomic) NSMutableArray *orientationUser;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *socialToken;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *locationId;
@property (strong, nonatomic) NSData *imageFileData;
@property (strong, nonatomic) NSNumber *isInterestedGendersHidden;
@property (strong, nonatomic) NSString *confirmPassword;

@property (strong, nonatomic) NSString *code;
@property (assign, nonatomic) BOOL isRecoveryPassword;
@property (assign, nonatomic) BOOL isRefresh;

- (instancetype)init;

- (instancetype)initWithLoginModel:(LoginModel *)loginModel;

@end

