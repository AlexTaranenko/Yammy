//
//  SocialNetworksMapping.m
//  Yammy
//
//  Created by Alex on 11/8/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SocialNetworksMapping.h"

@implementation SocialNetworksMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"facebook_id" : @"facebookId",
                                                @"google_id" : @"googleId",
                                                @"twitter_id" : @"twitterId"
                                                }];
  
  return mapping;
}

@end

