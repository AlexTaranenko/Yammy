//
//  GiftMapping.m
//  Yammy
//
//  Created by Alex on 10/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GiftMapping.h"

@implementation GiftMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdGift",
                                                @"Title" : @"Title",
                                                @"Description" : @"Description",
                                                @"Price" : @"Price",
                                                @"GiftType" : @"GiftType",
                                                @"Type" : @"Type"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"Image" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

@end


// User gift mapping

@implementation UserGiftMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdUserGift",
                                                @"ToUserId" : @"ToUserId",
                                                @"FromUserId" : @"FromUserId",
                                                @"GiftId" : @"GiftId",
                                                @"EventDate" : @"EventDate",
                                                @"Status" : @"Status",
                                                @"EventStatusTyped" : @"EventStatusTyped",
                                                @"EventTypeTyped" : @"EventTypeTyped"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Gift" toKeyPath:@"Gift" withMapping:[GiftMapping objectMapping]]];
  
  return mapping;
}

@end

@implementation MyGiftMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"FromUserId" : @"FromUserId",
                                                @"EventDate" : @"EventDate",
                                                @"Title" : @"Title",
                                                @"SubTitle" : @"SubTitle"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Gift" toKeyPath:@"Gift" withMapping:[GiftMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUser" toKeyPath:@"FromUser" withMapping:[ProfileMapping objectMapping]]];
  
  return mapping;
}

@end

