//
//  VerifyMapping.m
//  Yammy
//
//  Created by Alex on 5/14/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "VerifyMapping.h"

@implementation VerifyMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdVerify",
                                                @"Title" : @"Title"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"Image" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

@end
