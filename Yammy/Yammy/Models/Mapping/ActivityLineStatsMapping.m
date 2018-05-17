//
//  ActivityLineStatsMapping.m
//  Yammy
//
//  Created by Alex on 12/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ActivityLineStatsMapping.h"

@implementation ActivityLineStatsMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"All" : @"All",
                                                @"Chats" : @"Chats",
                                                @"Likes" : @"Likes",
                                                @"Matches" : @"Matches"
                                                }];
  
  return mapping;
}

@end

