//
//  PublicProfileAboutMeModel.h
//  Yammy
//
//  Created by Alex on 10/31/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicProfileAboutMeModel : NSObject

@property (strong, nonatomic) NSString *FirstName;
@property (strong, nonatomic) NSString *LastName;
@property (strong, nonatomic) NSNumber *SexId;
@property (strong, nonatomic) NSNumber *BirthDate;
@property (strong, nonatomic) NSString *Phone;
@property (strong, nonatomic) NSNumber *PhoneConfirmed;
@property (strong, nonatomic) NSString *Email;
@property (strong, nonatomic) NSNumber *EmailConfirmed;
@property (strong, nonatomic) NSNumber *RelationshipId;
@property (strong, nonatomic) NSNumber *GenderId;
@property (strong, nonatomic) NSNumber *Height;
@property (strong, nonatomic) NSNumber *Weight;
@property (strong, nonatomic) NSNumber *LiveWithId;
@property (strong, nonatomic) NSNumber *AlcoholId;
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
@property (strong, nonatomic) NSArray *relationsArray;
@property (strong, nonatomic) NSArray *orientationsArray;
@property (strong, nonatomic) NSArray *livesArray;
@property (strong, nonatomic) NSArray *childrenArray;
@property (strong, nonatomic) NSArray *bodyArray;
@property (strong, nonatomic) NSArray *smokingArray;
@property (strong, nonatomic) NSArray *alchogolArray;
@property (strong, nonatomic) NSArray *jobArray;
@property (strong, nonatomic) NSArray *languageArray;
@property (strong, nonatomic) NSArray *traitArray;
@property (strong, nonatomic) NSMutableArray *selectedTraits;
@property (strong, nonatomic) NSArray *InterestedGenders;
@property (strong, nonatomic) NSMutableArray *selectedInterestedGenders;
@property (strong, nonatomic) NSArray *genders;
@property (strong, nonatomic) NSNumber *IsGenderHidden;
@property (strong, nonatomic) NSNumber *IsInterestedGendersHidden;
@property (strong, nonatomic) NSString *City;
@property (strong, nonatomic) NSString *Country;

- (void)setupValuesByProfileMapping:(ProfileMapping *)profileMapping;

@end

