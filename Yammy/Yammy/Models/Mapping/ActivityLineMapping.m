//
//  ActivityLineMapping.m
//  Yammy
//
//  Created by Alex on 12/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ActivityLineMapping.h"

@implementation ActivityLineMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"EventType" : @"EventType",
                                                @"EventDate" : @"EventDate",
                                                @"Title" : @"Title",
                                                @"SubTitle" : @"SubTitle",
                                                @"FromUserId" : @"FromUserId",
                                                @"MediaUrl" : @"MediaUrl",
                                                @"Ids" : @"Ids",
                                                @"Id" : @"IdActivityLine",
                                                @"Description" : @"Description"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUser" toKeyPath:@"FromUser" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Match" toKeyPath:@"Match" withMapping:[MatchMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Gift" toKeyPath:@"Gift" withMapping:[GiftMapping objectMapping]]];
  
  return mapping;
}

@end


// Activity Lines

@implementation ActivityLinesMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Group" : @"Group"}];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Items" toKeyPath:@"Items" withMapping:[ActivityLineMapping objectMapping]]];
  
  return mapping;
}

@end

