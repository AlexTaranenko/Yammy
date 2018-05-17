//
//  InterestsMapping.m
//  Yammy
//
//  Created by Alex on 12.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "InterestsMapping.h"

@implementation InterestMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdInterest",
                                                @"Title" : @"Title",
                                                @"Group" : @"Group"
                                                }];
  
  return mapping;
}

@end



@implementation InterestsMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Group" : @"Group"}];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Items" toKeyPath:@"Items" withMapping:[InterestMapping objectMapping]]];
  
  return mapping;
}

@end

