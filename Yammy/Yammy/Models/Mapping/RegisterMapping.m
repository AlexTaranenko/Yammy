//
//  RegisterMapping.m
//  Yammy
//
//  Created by Alex on 24.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "RegisterMapping.h"
#import "StringMapping.h"

@implementation RegisterMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{
                                                @"Token" : @"token",
                                                @"code" : @"code",
                                                @"message" : @"message",
                                                @"localized" : @"localized"
                                                }];
  
  return mapping;
}

@end

