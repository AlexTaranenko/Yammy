//
//  UserSettingsMapping.m
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "UserSettingsMapping.h"

@implementation UserSettingsMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"UserId" : @"UserId",
                                                @"AllowToShareProfile" : @"AllowToShareProfile",
                                                @"VisibleToSearchEngines" : @"VisibleToSearchEngines",
                                                @"NotifyOnChat" : @"NotifyOnChat",
                                                @"NotifyOnLike" : @"NotifyOnLike",
                                                @"NotifyOnSuperLike" : @"NotifyOnSuperLike",
                                                @"NotifyOnFollower" : @"NotifyOnFollower",
                                                @"Subscribed" : @"Subscribed",
                                                @"NotifyOnGift" : @"NotifyOnGift",
                                                @"HideLinkedAccounts" : @"HideLinkedAccounts",
                                                @"Hidden" : @"Hidden",
                                                @"LanguageId" : @"LanguageId",
                                                @"TranslateChats" : @"TranslateChats",
                                                @"DeleteRequested" : @"DeleteRequested",
                                                @"DeleteAfter" : @"DeleteAfter"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Language" toKeyPath:@"Language" withMapping:[LanguageMapping objectMapping]]];
  
  return mapping;
}

@end

