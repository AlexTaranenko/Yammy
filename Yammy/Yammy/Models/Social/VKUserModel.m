//
//  VKUser.m
//  Yammy
//
//  Created by Alex on 8/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "VKUserModel.h"

@implementation VKUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  if (self) {
    self.firstName = [dictionary objectForKey:@"first_name"];
    self.lastName = [dictionary objectForKey:@"last_name"];
    self.bdate = [dictionary objectForKey:@"bdate"];
    self.idUser = [dictionary objectForKey:@"id"];
    self.homePhone = [dictionary objectForKey:@"home_phone"];
    self.mobilePhone = [dictionary objectForKey:@"mobile_phone"];
    self.photo_100 = [dictionary objectForKey:@"photo_100"];
    self.photo_200_orig = [dictionary objectForKey:@"photo_200_orig"];
    self.photo_max = [dictionary objectForKey:@"photo_max"];
  }
  return self;
}

@end
