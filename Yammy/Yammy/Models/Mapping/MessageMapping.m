//
//  MessageMapping.m
//  Yammy
//
//  Created by Alex on 11/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MessageMapping.h"

@implementation MessageMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"EventStatusTyped" : @"EventStatusTyped",
                                                @"EventTypeTyped" : @"EventTypeTyped",
                                                @"Id" : @"IdMessage",
                                                @"FromUserId" : @"FromUserId",
                                                @"ToUserId" : @"ToUserId",
                                                @"Status" : @"Status",
                                                @"EventDate" : @"EventDate",
                                                @"Message" : @"Message",
                                                @"GiftId" : @"GiftId",
                                                @"IsGift" : @"IsGift",
                                                @"IsAudio" : @"IsAudio",
                                                @"IsImage" : @"IsImage",
                                                @"Title" : @"Title",
                                                @"SubTitle" : @"SubTitle",
                                                @"StickerId" : @"StickerId"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Gift" toKeyPath:@"Gift" withMapping:[GiftMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"Image" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ToUser" toKeyPath:@"ToUser" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUser" toKeyPath:@"FromUser" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Audio" toKeyPath:@"Audio" withMapping:[AudioMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Sticker" toKeyPath:@"Sticker" withMapping:[DictionaryMapping objectMapping]]];
  
  return mapping;
}

@end

