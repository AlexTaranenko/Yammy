//
//  TwitterUser.m
//  Yammy
//
//  Created by Alex on 10.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TwitterUser.h"

@implementation TwitterUser

- (instancetype)initWithDictionary:(NSDictionary *)user {
  self = [super init];
  
  if(self) {
    self.userID = [[user objectForKey:@"id"] stringValue];
    self.profileURL = [user objectForKey:@"profile_image_url"];
    self.profileURL = [self.profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    
    NSURL *url = [NSURL URLWithString:self.profileURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.profileImage = [UIImage imageWithData:data];
    
    self.name = [user objectForKey:@"name"];
    self.hometown = [user objectForKey:@"location"];  
  }
  
  return self;
}


@end
