//
//  UserCircleMapping.m
//  Yammy
//
//  Created by Alex on 13.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UserCircleMapping.h"

@implementation UserCircleMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"id" : @"idUserCircle",
                                                @"email" : @"email",
                                                @"full_name" : @"fullName",
                                                @"gender" : @"gender",
                                                @"image_url" : @"imageUrl",
                                                @"circle_type" : @"circleType",
                                                @"bezel" : @"bezel"
                                                }];
  
  return mapping;
}

@end
