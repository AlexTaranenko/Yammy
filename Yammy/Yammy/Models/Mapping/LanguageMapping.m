//
//  LanguageMapping.m
//  Yammy
//
//  Created by Alex on 01.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LanguageMapping.h"

@implementation LanguageMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdLanguage",
                                                @"Name" : @"Name",
                                                @"LCID" : @"LCID",
                                                @"NativeName" : @"NativeName",
                                                @"EnglishName" : @"EnglishName",
                                                @"Rank" : @"Rank",
                                                @"ParentLanguageId" : @"ParentLanguageId",
                                                @"Enabled" : @"Enabled"
                                                }];
  
  return mapping;
}

@end
