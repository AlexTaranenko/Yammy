//
//  ContactMapping.m
//  Yammy
//
//  Created by Alex on 12/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ContactMapping.h"

@implementation ContactMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" :@"IdContact",
                                                @"UserId" : @"UserId",
                                                @"ContactUserId" : @"ContactUserId",
                                                @"LinkedOn" : @"LinkedOn",
                                                @"Note" : @"Note"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ContactUser" toKeyPath:@"ContactUser" withMapping:[ProfileMapping objectMapping]]];
  
  return mapping;
}

@end

