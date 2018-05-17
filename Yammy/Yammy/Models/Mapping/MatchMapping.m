//
//  MatchMapping.m
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MatchMapping.h"

@implementation MatchMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdMatch",
                                                @"FromUserId" : @"FromUserId",
                                                @"ToUserId" : @"ToUserId",
                                                @"Status" : @"Status",
                                                @"EventDate" : @"EventDate",
                                                @"EventStatusTyped" : @"EventStatusTyped",
                                                @"EventTypeTyped" : @"EventTypeTyped",
                                                @"SubTitle" : @"SubTitle",
                                                @"Title" : @"Title"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ToUser" toKeyPath:@"ToUser" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"FromUser" toKeyPath:@"FromUser" withMapping:[ProfileMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PrivatePreferences" toKeyPath:@"PrivatePreferences" withMapping:[PreferencesMapping objectMapping]]];
  
  return mapping;
}

@end

