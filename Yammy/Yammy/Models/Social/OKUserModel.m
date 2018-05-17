//
//  OKUserModel.m
//  Yammy
//
//  Created by Alex on 16.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "OKUserModel.h"

@implementation OKUserModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];
  
  if (self) {
    self.age = [dictionary objectForKey:@"age"];
    self.birthday = [dictionary objectForKey:@"birthday"];
    self.firstName = [dictionary objectForKey:@"first_name"];
    self.gender = [dictionary objectForKey:@"gender"];
    self.lastName = [dictionary objectForKey:@"last_name"];
    self.uid = [dictionary objectForKey:@"uid"];
  }
  
  return self;
}

@end
