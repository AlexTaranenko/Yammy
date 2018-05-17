//
//  ProfileMapping.h
//  Yammy
//
//  Created by Alex on 11/22/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftMapping.h"
#import "ServicesMapping.h"
#import "DictionaryMapping.h"
#import "LocationMapping.h"

@interface ProfileMapping : NSObject

@property (strong, nonatomic) NSNumber *UserId;
@property (strong, nonatomic) NSString *FirstName;
@property (strong, nonatomic) NSString *LastName;
@property (strong, nonatomic) NSNumber *SexId;
@property (strong, nonatomic) NSNumber *BirthDate;
@property (strong, nonatomic) NSString *Phone;
@property (strong, nonatomic) NSNumber *PhoneConfirmed;
@property (strong, nonatomic) NSString *Email;
@property (strong, nonatomic) NSNumber *EmailConfirmed;
@property (strong, nonatomic) NSString *EmailConfirmationCode;
@property (strong, nonatomic) NSNumber *RelationshipId;
@property (strong, nonatomic) NSNumber *GenderId;
@property (strong, nonatomic) NSNumber *Height;
@property (strong, nonatomic) NSNumber *Weight;
@property (strong, nonatomic) NSNumber *LiveWithId;
@property (strong, nonatomic) NSNumber *KidId;
@property (strong, nonatomic) NSNumber *BodyTypeId;
@property (strong, nonatomic) NSNumber *SmokingId;
@property (strong, nonatomic) NSNumber *JobId;
@property (strong, nonatomic) NSNumber *LanguageId;
@property (strong, nonatomic) NSNumber *Latitude;
@property (strong, nonatomic) NSNumber *Longitude;
@property (strong, nonatomic) NSNumber *LocationId;
@property (strong, nonatomic) NSString *InfoAbout;
@property (strong, nonatomic) NSString *InfoAboutLove;
@property (strong, nonatomic) NSString *InfoAboutFamily;
@property (strong, nonatomic) NSString *InfoAboutSex;
@property (strong, nonatomic) NSNumber *Rating;
@property (strong, nonatomic) NSNumber *AlcoholId;
@property (strong, nonatomic) ImageMapping *PrimaryPhoto;
@property (strong, nonatomic) NSArray *Photos;
@property (strong, nonatomic) NSArray *Gifts;
@property (strong, nonatomic) NSArray *Services;
@property (strong, nonatomic) NSArray *Interests;
@property (strong, nonatomic) NSArray *Traits;
@property (strong, nonatomic) NSNumber *IsMyContact;
@property (strong, nonatomic) NSNumber *IsLikedByMe;
@property (strong, nonatomic) NSNumber *IsSuperLikedByMe;
@property (strong, nonatomic) NSNumber *CircleSize;
@property (strong, nonatomic) NSNumber *HasPrivateProfile; // First strawberry
@property (strong, nonatomic) NSNumber *IsPrivateProfileHidden; // First lock
@property (strong, nonatomic) NSNumber *HasPrivateProfileGeneralInfo; // Second strawberry
@property (strong, nonatomic) NSNumber *IsPrivateProfileGeneralInfoHidden; // Second lock
@property (strong, nonatomic) NSNumber *HasPrivateProfilePrivateInteresets; // Three strawberry
@property (strong, nonatomic) NSNumber *IsPrivateProfilePrivateInteresetsHidden; // Three lock
@property (strong, nonatomic) NSNumber *HasPrivateProfilePrivatePreferences; // Four strawberry
@property (strong, nonatomic) NSNumber *IsPrivateProfilePrivatePreferencesHidden; // Four strawberry
@property (strong, nonatomic) NSNumber *IsOnline;
@property (strong, nonatomic) NSNumber *Balance;
@property (strong, nonatomic) NSArray *InterestedGenders;
@property (strong, nonatomic) NSNumber *IsGenderHidden;
@property (strong, nonatomic) NSNumber *IsInterestedGendersHidden;
@property (strong, nonatomic) DictionaryMapping *Sex;
@property (strong, nonatomic) CountryMapping *Location;
@property (strong, nonatomic) NSNumber *IsBlocked;
@property (strong, nonatomic) NSString *City;
@property (strong, nonatomic) NSString *Country;
@property (strong, nonatomic) NSNumber *SharingAllowed;

+ (RKObjectMapping *)objectMapping;

@end

