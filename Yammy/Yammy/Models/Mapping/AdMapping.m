//
//  AdMapping.m
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "AdMapping.h"

@implementation AdMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Type" : @"Type"}];
  
  return mapping;
}

@end
