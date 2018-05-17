//
//  PublicProfileAboutMeModel.m
//  Yammy
//
//  Created by Alex on 10/31/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PublicProfileAboutMeModel.h"

@implementation PublicProfileAboutMeModel

- (void)setupValuesByProfileMapping:(ProfileMapping *)profileMapping {
  self.FirstName = profileMapping.FirstName;
  self.LastName = profileMapping.LastName;
  self.SexId = profileMapping.SexId;
  self.BirthDate = profileMapping.BirthDate;
  self.Phone = profileMapping.Phone;
  self.PhoneConfirmed = profileMapping.PhoneConfirmed;
  self.Email = profileMapping.Email;
  self.EmailConfirmed = profileMapping.EmailConfirmed;
  self.RelationshipId = profileMapping.RelationshipId;
  self.GenderId = profileMapping.GenderId;
  self.Height = profileMapping.Height;
  self.Weight = profileMapping.Weight;
  self.LiveWithId = profileMapping.LiveWithId;
  self.AlcoholId = profileMapping.AlcoholId;
  self.KidId = profileMapping.KidId;
  self.BodyTypeId = profileMapping.BodyTypeId;
  self.SmokingId = profileMapping.SmokingId;
  self.JobId = profileMapping.JobId;
  self.LanguageId = profileMapping.LanguageId;
  self.Latitude = profileMapping.Latitude;
  self.Longitude = profileMapping.Longitude;
  self.LocationId = profileMapping.LocationId;
  self.InfoAbout = profileMapping.InfoAbout;
  self.InfoAboutLove = profileMapping.InfoAboutLove;
  self.InfoAboutFamily = profileMapping.InfoAboutFamily;
  self.InfoAboutSex = profileMapping.InfoAboutSex;
  self.Rating = profileMapping.Rating;
  self.selectedTraits = [NSMutableArray arrayWithArray:profileMapping.Traits];
  self.selectedInterestedGenders = [NSMutableArray arrayWithArray:profileMapping.InterestedGenders];
  self.IsGenderHidden = profileMapping.IsGenderHidden;
  self.IsInterestedGendersHidden = profileMapping.IsInterestedGendersHidden;
  self.City = profileMapping.City;
  self.Country = profileMapping.Country;
}

@end

