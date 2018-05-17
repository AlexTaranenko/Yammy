//
//  ChatMapping.m
//  Yammy
//
//  Created by Alex on 11/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ChatMapping.h"

@implementation ChatMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Title" : @"Title",
                                                @"SubTitle" : @"SubTitle",
                                                @"EventDate" : @"EventDate",
                                                @"WithUserId" : @"WithUserId",
                                                @"OpponentIsOnline" : @"OpponentIsOnline",
                                                @"UnSeen" : @"UnSeen",
                                                @"ChatStatus" : @"ChatStatus",
                                                @"IsBlocked" : @"IsBlocked",
                                                @"IsIncoming" : @"IsIncoming"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"OpponentUserPhoto" toKeyPath:@"OpponentUserPhoto" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

@end


@implementation ChatListMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Group" : @"Group"}];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Items" toKeyPath:@"Items" withMapping:[ChatMapping objectMapping]]];
  
  return mapping;
}

@end
