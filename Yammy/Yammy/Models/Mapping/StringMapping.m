//
//  StringMapping.m
//  Yammy
//
//  Created by Alex on 24.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "StringMapping.h"

@implementation StringMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"text"]];
  
  return mapping;
}

@end
