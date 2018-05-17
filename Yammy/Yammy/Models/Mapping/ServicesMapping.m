//
//  ServicesMapping.m
//  Yammy
//
//  Created by Alex on 25.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ServicesMapping.h"

@implementation ServicesMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdServices",
                                                @"SystemCode" : @"SystemCode",
                                                @"Title" : @"Title",
                                                @"Description" : @"Description",
                                                @"Price" : @"Price",
                                                @"Enabled" : @"Enabled",
                                                @"IsPopular" : @"IsPopular",
                                                @"PaidEntityType" : @"PaidEntityType",
                                                @"GiftId" : @"GiftId",
                                                @"ServiceId" : @"ServiceId",
                                                @"StickerId" : @"StickerId"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Icon" toKeyPath:@"Icon" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

@end


@implementation UserServicesMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdUserServices",
                                                @"UserId" : @"UserId",
                                                @"ServiceId" : @"ServiceId",
                                                @"DueTo" : @"DueTo",
                                                @"CreatedOn" : @"CreatedOn"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Service" toKeyPath:@"Service" withMapping:[ServicesMapping objectMapping]]];
  
  return mapping;
}

@end

