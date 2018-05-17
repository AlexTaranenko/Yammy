//
//  RegisterModel.m
//  Yammy
//
//  Created by Alex on 8/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel

- (instancetype)init {
  self = [super init];
  
  if (self) {
    self.typeUser = @"Native";
    self.nameUser = nil;
    self.birthdayUser = [Helpers defaultDate];
    self.sexUser = nil;
    self.orientationUser = [NSMutableArray new];
    self.phoneNumber = nil;
    self.email = nil;
    self.socialToken = nil;
    self.deviceToken = nil;
    self.password = nil;
    self.locationId = nil;
    self.imageFileData = nil;
    self.isInterestedGendersHidden = nil;
    self.code = nil;
    self.isRecoveryPassword = NO;
    self.isRefresh = NO;
    self.confirmPassword = nil;
  }
  
  return self;
}

- (instancetype)initWithLoginModel:(LoginModel *)loginModel {
  self = [super init];
  
  if (self) {
    self.typeUser = loginModel.type;
    self.nameUser = loginModel.nameUser;
    self.birthdayUser = loginModel.birthdayUser;
    self.sexUser = loginModel.sexUser;
    self.phoneNumber = loginModel.phoneNumber;
    self.email = loginModel.email;
    self.socialToken = loginModel.socialToken;
    self.imageFileData = loginModel.imageFileData;
    self.isRecoveryPassword = NO;
    self.isRefresh = NO;
  }
  
  return self;
}

@end

