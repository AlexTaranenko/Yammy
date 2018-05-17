//
//  LocationMapping.m
//  Yammy
//
//  Created by Alex on 12/15/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LocationMapping.h"

@implementation LocationMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdLocation",
                                                @"Title" : @"Title",
                                                @"ParentLocationId" : @"ParentLocationId",
                                                @"Latitude" : @"Latitude",
                                                @"Longitude" : @"Longitude"
                                                }];
  
  //  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Locations" toKeyPath:@"Locations" withMapping:[LocationMapping objectMapping]]];
  
  return mapping;
}

@end


// Parent

@implementation CountryMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdLocation",
                                                @"Title" : @"Title",
                                                @"ParentLocationId" : @"ParentLocationId",
                                                @"Latitude" : @"Latitude",
                                                @"Longitude" : @"Longitude"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Locations" toKeyPath:@"Locations" withMapping:[LocationMapping objectMapping]]];
  
  return mapping;
}

@end

