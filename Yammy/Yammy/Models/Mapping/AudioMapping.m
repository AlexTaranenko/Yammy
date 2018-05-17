//
//  AudioMapping.m
//  Yammy
//
//  Created by Alex on 12/27/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AudioMapping.h"

@implementation AudioMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdAudio",
                                                @"Url" : @"Url"
                                                }];
  
  return mapping;
}

@end

