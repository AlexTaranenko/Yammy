//
//  LikeMapping.m
//  Yammy
//
//  Created by Alex on 12/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LikeMapping.h"

@implementation LikeMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdLike",
                                                @"FromUserId" : @"FromUserId",
                                                @"ToUserId" : @"ToUserId",
                                                @"Status" : @"Status",
                                                @"EventDate" : @"EventDate",
                                                @"IsSuper" : @"IsSuper",
                                                @"SubTitle" : @"SubTitle"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUser" toKeyPath:@"FromUser" withMapping:[ProfileMapping objectMapping]]];
  
  return mapping;
}

@end

