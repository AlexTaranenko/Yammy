//
//  ProfileMapping.m
//  Yammy
//
//  Created by Alex on 11/22/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileMapping.h"

@implementation ProfileMapping

+ (RKObjectMapping *)objectMapping {
  RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
  
  [mapping addAttributeMappingsFromDictionary:@{@"UserId" : @"UserId",
                                                @"FirstName" : @"FirstName",
                                                @"LastName" : @"LastName",
                                                @"SexId" : @"SexId",
                                                @"BirthDate" : @"BirthDate",
                                                @"Phone" : @"Phone",
                                                @"PhoneConfirmed" : @"PhoneConfirmed",
                                                @"Email" : @"Email",
                                                @"EmailConfirmed" : @"EmailConfirmed",
                                                @"EmailConfirmationCode" : @"EmailConfirmationCode",
                                                @"RelationshipId" : @"RelationshipId",
                                                @"GenderId" : @"GenderId",
                                                @"Height" : @"Height",
                                                @"Weight" : @"Weight",
                                                @"LiveWithId" : @"LiveWithId",
                                                @"KidId" : @"KidId",
                                                @"BodyTypeId" : @"BodyTypeId",
                                                @"SmokingId" : @"SmokingId",
                                                @"JobId" : @"JobId",
                                                @"LanguageId" : @"LanguageId",
                                                @"Latitude" : @"Latitude",
                                                @"Longitude" : @"Longitude",
                                                @"LocationId" : @"LocationId",
                                                @"InfoAbout" : @"InfoAbout",
                                                @"InfoAboutLove" : @"InfoAboutLove",
                                                @"InfoAboutFamily" : @"InfoAboutFamily",
                                                @"InfoAboutSex" : @"InfoAboutSex",
                                                @"Rating" : @"Rating",
                                                @"AlcoholId" : @"AlcoholId",
                                                @"IsMyContact" : @"IsMyContact",
                                                @"IsLikedByMe" : @"IsLikedByMe",
                                                @"IsSuperLikedByMe" : @"IsSuperLikedByMe",
                                                @"CircleSize" : @"CircleSize",
                                                @"HasPrivateProfile" : @"HasPrivateProfile",
                                                @"IsPrivateProfileHidden" : @"IsPrivateProfileHidden",
                                                @"HasPrivateProfileGeneralInfo" : @"HasPrivateProfileGeneralInfo",
                                                @"IsPrivateProfileGeneralInfoHidden" : @"IsPrivateProfileGeneralInfoHidden",
                                                @"HasPrivateProfilePrivateInteresets" : @"HasPrivateProfilePrivateInteresets",
                                                @"IsPrivateProfilePrivateInteresetsHidden" : @"IsPrivateProfilePrivateInteresetsHidden",
                                                @"HasPrivateProfilePrivatePreferences" : @"HasPrivateProfilePrivatePreferences",
                                                @"IsPrivateProfilePrivatePreferencesHidden" : @"IsPrivateProfilePrivatePreferencesHidden",
                                                @"IsOnline" : @"IsOnline",
                                                @"Balance" : @"Balance",
                                                @"IsGenderHidden" : @"IsGenderHidden",
                                                @"IsInterestedGendersHidden" : @"IsInterestedGendersHidden",
                                                @"IsBlocked" : @"IsBlocked",
                                                @"City" : @"City",
                                                @"SharingAllowed" : @"SharingAllowed",
                                                @"Country" : @"Country"
                                                }];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Photos" toKeyPath:@"Photos" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"PrimaryPhoto" toKeyPath:@"PrimaryPhoto" withMapping:[ImageMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Gifts" toKeyPath:@"Gifts" withMapping:[UserGiftMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Services" toKeyPath:@"Services" withMapping:[ServicesMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Interests" toKeyPath:@"Interests" withMapping:[InterestMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Traits" toKeyPath:@"Traits" withMapping:[DictionaryMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"InterestedGenders" toKeyPath:@"InterestedGenders" withMapping:[DictionaryMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Sex" toKeyPath:@"Sex" withMapping:[DictionaryMapping objectMapping]]];
  
  [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Location" toKeyPath:@"Location" withMapping:[CountryMapping objectMapping]]];
  
  return mapping;
}

@end

