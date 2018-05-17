//
//  GenderMapping.m
//  Yammy
//
//  Created by Alex on 11/21/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "DictionaryMapping.h"

@implementation DictionaryMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdDictionary",
                                                @"Title" : @"Title",
                                                @"MaleFormatted" : @"MaleFormatted",
                                                @"FemaleFormatted" : @"FemaleFormatted",
                                                @"SexTyped" : @"SexTyped",
                                                @"Cost" : @"Cost",
                                                @"Type" : @"Type"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Icon" toKeyPath:@"Icon" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"Image" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.Title forKey:@"Title"];
  [aCoder encodeObject:self.SexTyped forKey:@"SexTyped"];
  [aCoder encodeObject:self.IdDictionary forKey:@"IdDictionary"];
  [aCoder encodeObject:self.MaleFormatted forKey:@"MaleFormatted"];
  [aCoder encodeObject:self.FemaleFormatted forKey:@"FemaleFormatted"];
  [aCoder encodeObject:self.Icon forKey:@"Icon"];
  [aCoder encodeObject:self.Image forKey:@"Image"];
  [aCoder encodeObject:self.Cost forKey:@"Cost"];
  [aCoder encodeObject:self.Type forKey:@"Type"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.Title = [aDecoder decodeObjectForKey:@"Title"];
    self.SexTyped = [aDecoder decodeObjectForKey:@"SexTyped"];
    self.IdDictionary = [aDecoder decodeObjectForKey:@"IdDictionary"];
    self.MaleFormatted = [aDecoder decodeObjectForKey:@"MaleFormatted"];
    self.FemaleFormatted = [aDecoder decodeObjectForKey:@"FemaleFormatted"];
    self.Icon = [aDecoder decodeObjectForKey:@"Icon"];
    self.Image = [aDecoder decodeObjectForKey:@"Image"];
    self.Cost = [aDecoder decodeObjectForKey:@"Cost"];
    self.Type = [aDecoder decodeObjectForKey:@"Type"];
  }
  
  return self;
}


@end

