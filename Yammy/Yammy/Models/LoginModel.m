//
//  LoginModel.m
//  Yammy
//
//  Created by Alex on 17.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (instancetype)init {
  self = [super init];
  
  if (self) {
    [self resetValues];
  }
  
  return self;
}

- (void)resetValues {
  self.phoneNumber = nil;
  self.email = nil;
  self.type = @"Native";
  self.password = nil;
  self.nameUser = nil;
  self.socialToken = nil;
  self.birthdayUser = [Helpers defaultDate];
  self.sexUser = nil;
  self.confirmPassword = nil;
  self.verificationCode = nil;
  self.imageFileData = nil;
}

- (void)setupValuesByFacebookUser:(FacebookUser *)facebookUser {
  self.email = facebookUser.email;
  self.nameUser = facebookUser.name;
  self.sexUser = [facebookUser.gender isEqualToString:@"male"] ? @(1) : @(2);
  NSURL *urlImage = [NSURL URLWithString:facebookUser.profileURL];
  if (urlImage) {
    self.imageFileData = [NSData dataWithContentsOfURL:urlImage];
  }
}

@end

