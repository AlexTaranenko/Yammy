//
//  PreferencesMapping.m
//  Yammy
//
//  Created by Alex on 11/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PreferencesMapping.h"

@implementation PreferencesMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Title" : @"Title",
                                                @"Id" : @"IdPreferences"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Icon" toKeyPath:@"Icon" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.Title forKey:@"Title"];
  [aCoder encodeObject:self.IdPreferences forKey:@"IdPreferences"];
  [aCoder encodeObject:self.Icon forKey:@"Icon"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.Title = [aDecoder decodeObjectForKey:@"Title"];
    self.IdPreferences = [aDecoder decodeObjectForKey:@"IdPreferences"];
    self.Icon = [aDecoder decodeObjectForKey:@"Icon"];
  }
  return self;
}

@end

