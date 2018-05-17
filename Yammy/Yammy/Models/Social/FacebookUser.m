//
//  FacebookUser.m
//  Yammy
//
//  Created by Alex on 09.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "FacebookUser.h"

@implementation FacebookUser

- (id)initWithDictionary:(NSDictionary *)infos {
  self = [super init];
  
  if(self) {
    self.name = [infos objectForKey:@"name"];
    self.userID = [infos objectForKey:@"id"];
    self.email = [infos objectForKey:@"email"];
    self.gender = [infos objectForKey:@"gender"];
    self.profileURL = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.userID];
    self.firstName = [infos objectForKey:@"first_name"];
    self.lastName = [infos objectForKey:@"last_name"];
    
    NSURL *url = [NSURL URLWithString:self.profileURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.profileImage = [UIImage imageWithData:data];
  }
  
  return self;
}

@end
