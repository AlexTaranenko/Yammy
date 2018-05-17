//
//  PeoplesMapping.m
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "PeoplesMapping.h"

@implementation PeoplesMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Profiles" toKeyPath:@"Profiles" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Match" toKeyPath:@"Match" withMapping:[MatchMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Ad" toKeyPath:@"Ad" withMapping:[AdMapping objectMapping]]];
  
  return mapping;
}

@end
