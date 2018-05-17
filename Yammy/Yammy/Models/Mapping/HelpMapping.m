//
//  HelpMapping.m
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HelpMapping.h"

@implementation HelpMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdHelp",
                                                @"Title" : @"Title"}];
  
  return mapping;
}

@end



@implementation ArticleMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"Id" : @"IdArticle",
                                                @"HelpTopicId" : @"HelpTopicId",
                                                @"Title" : @"Title",
                                                @"Content" : @"Content"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Image" toKeyPath:@"Image" withMapping:[ImageMapping objectMapping]]];
  
  return mapping;
}

@end

