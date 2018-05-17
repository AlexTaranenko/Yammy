//
//  PrivateProfileMapping.m
//  Yammy
//
//  Created by Alex on 11/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PrivateProfileMapping.h"

@implementation PrivateProfileMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"UserId" : @"UserId",
                                                @"IsHidden" : @"IsHidden",
                                                @"NickName" : @"NickName",
                                                @"GeneralInfoHidden" : @"GeneralInfoHidden",
                                                @"FirstSexWith" : @"FirstSexWith",
                                                @"FirstSexWhen" : @"FirstSexWhen",
                                                @"FirstSexWhere" : @"FirstSexWhere",
                                                @"ReadyToNewSexHorizons" : @"ReadyToNewSexHorizons",
                                                @"PenisLengthOrBreastSize" : @"PenisLengthOrBreastSize",
                                                @"PrivateInterestsHidden" : @"PrivateInterestsHidden",
                                                @"HaveFilmedHomeSex" : @"HaveFilmedHomeSex",
                                                @"ReadyToFirstSex" : @"ReadyToFirstSex",
                                                @"SexPassions" : @"SexPassions",
                                                @"SexFrequency" : @"SexFrequency",
                                                @"VirtualSex" : @"VirtualSex",
                                                @"PrivatePreferencesHidden" : @"PrivatePreferencesHidden",
                                                @"IsBlocked" : @"IsBlocked"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PrimaryPhoto" toKeyPath:@"PrimaryPhoto" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Photos" toKeyPath:@"Photos" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PrivatePreferences" toKeyPath:@"PrivatePreferences" withMapping:[PreferencesMapping objectMapping]]];
  
  return mapping;
}

@end

