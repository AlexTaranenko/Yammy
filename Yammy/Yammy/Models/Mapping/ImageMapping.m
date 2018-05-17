//
//  ImageMapping.m
//  Yammy
//
//  Created by Alex on 9/28/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ImageMapping.h"

@implementation ImageMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdImage",
                                                @"Url" : @"Url"
                                                }];
  
  return mapping;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.IdImage forKey:@"IdImage"];
  [aCoder encodeObject:self.Url forKey:@"Url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super init]) {
    self.IdImage = [aDecoder decodeObjectForKey:@"IdImage"];
    self.Url = [aDecoder decodeObjectForKey:@"Url"];
  }
  return self;
}

@end

