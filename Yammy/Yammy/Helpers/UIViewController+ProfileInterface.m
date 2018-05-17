//
//  UIViewController+ProfileInterface.m
//  Yammy
//
//  Created by Alex on 11/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UIViewController+ProfileInterface.h"

@implementation UIViewController (ProfileInterface)

- (void)presentNameAlertWithName:(NSString *)name withCompletion:(void(^)(NSString *outputText))completion {
  [UIAlertHelper alertTextField:name title:@"Имя" placehodelr:nil withOkButton:@"Ок" withCancelButton:@"Отмена" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction, UITextField *textField) {
    if (successAction) {
      completion(textField.text);
    }
  }];
}

- (void)presentBirthdayAlertByDate:(NSDate *)date withCompletion:(void(^)(NSDate *date))completion {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  UIDatePicker *picker = [[UIDatePicker alloc] init];
  picker.timeZone = [NSTimeZone defaultTimeZone];
  picker.date = date;
  picker.maximumDate = [self dateFromComponentsByDate:[NSDate date]];
  [picker setDatePickerMode:UIDatePickerModeDate];
  [alertController.view addSubview:picker];
  
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"Применить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completion(picker.date);
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отменить" style:UIAlertActionStyleCancel handler:nil];
  
  [alertController addAction:action];
  [alertController addAction:cancelAction];
  
  [DELEGATE.window.rootViewController presentViewController:alertController  animated:YES completion:nil];
}

- (NSDate *)dateFromComponentsByDate:(NSDate *)date {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  [components setYear:[components year] - 18];
  [components setMonth:[components month]];
  [components setDay:[components day]];
  return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDictionary *)paramsForUpdateAboutMeWithPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel {
  NSMutableDictionary *mutDictionary = [NSMutableDictionary new];
  [mutDictionary setObject:[Helpers getAccessToken] forKey:@"Token"];
  
  if (publicProfileAboutMeModel.FirstName != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.FirstName forKey:@"FirstName"];
  
  if (publicProfileAboutMeModel.LastName != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.LastName forKey:@"LastName"];
  
  if (publicProfileAboutMeModel.SexId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.SexId forKey:@"SexId"];
  
  if (publicProfileAboutMeModel.BirthDate != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.BirthDate forKey:@"BirthDate"];
  
  if (publicProfileAboutMeModel.Phone != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.Phone forKey:@"Phone"];
  
  if (publicProfileAboutMeModel.Email != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.Email forKey:@"Email"];
  
  if (publicProfileAboutMeModel.RelationshipId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.RelationshipId forKey:@"RelationshipId"];
  
  if (publicProfileAboutMeModel.GenderId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.GenderId forKey:@"GenderId"];
  
  if (publicProfileAboutMeModel.Height != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.Height forKey:@"Height"];
  
  if (publicProfileAboutMeModel.Weight != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.Weight forKey:@"Weight"];
  
  if (publicProfileAboutMeModel.LiveWithId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.LiveWithId forKey:@"LiveWithId"];
  
  if (publicProfileAboutMeModel.KidId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.KidId forKey:@"KidId"];
  
  if (publicProfileAboutMeModel.BodyTypeId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.BodyTypeId forKey:@"BodyTypeId"];
  
  if (publicProfileAboutMeModel.SmokingId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.SmokingId forKey:@"SmokingId"];
  
  if (publicProfileAboutMeModel.JobId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.JobId forKey:@"JobId"];
  
  if (publicProfileAboutMeModel.LanguageId != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.LanguageId forKey:@"LanguageId"];
  
  if (publicProfileAboutMeModel.InfoAbout != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.InfoAbout forKey:@"InfoAbout"];
  
  if (publicProfileAboutMeModel.InfoAboutLove != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.InfoAboutLove forKey:@"InfoAboutLove"];
  
  if (publicProfileAboutMeModel.InfoAboutFamily != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.InfoAboutFamily forKey:@"InfoAboutFamily"];
  
  if (publicProfileAboutMeModel.InfoAboutSex != nil)
    [mutDictionary setObject:publicProfileAboutMeModel.InfoAboutSex forKey:@"InfoAboutSex"];
  
  if (publicProfileAboutMeModel.Country != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.Country forKey:@"Country"];
  }

  if (publicProfileAboutMeModel.City != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.City forKey:@"City"];
  }

  if (publicProfileAboutMeModel.Latitude != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.Latitude forKey:@"Latitude"];
  }
  
  if (publicProfileAboutMeModel.Longitude != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.Longitude forKey:@"Longitude"];
  }
  
  if (publicProfileAboutMeModel.selectedTraits.count > 0) {
    NSMutableString *mutString = [NSMutableString new];
    for (DictionaryMapping *mapping in publicProfileAboutMeModel.selectedTraits) {
      NSInteger index = [publicProfileAboutMeModel.selectedTraits indexOfObject:mapping];
      [mutString appendFormat:@"%@", mapping.IdDictionary];
      if (index + 1 != publicProfileAboutMeModel.selectedTraits.count) {
        [mutString appendString:@","];
      }
    }
    [mutDictionary setObject:mutString forKey:@"Traits"];
  }
  
  if (publicProfileAboutMeModel.selectedInterestedGenders.count > 0) {
    NSMutableString *mutString = [NSMutableString new];
    for (DictionaryMapping *mapping in publicProfileAboutMeModel.selectedInterestedGenders) {
      NSInteger index = [publicProfileAboutMeModel.selectedInterestedGenders indexOfObject:mapping];
      [mutString appendFormat:@"%@", mapping.IdDictionary];
      if (index + 1 != publicProfileAboutMeModel.selectedInterestedGenders.count) {
        [mutString appendString:@","];
      }
    }
    [mutDictionary setObject:mutString forKey:@"InterestedGenderIds"];
  }
  
  if (publicProfileAboutMeModel.IsInterestedGendersHidden != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.IsInterestedGendersHidden forKey:@"IsInterestedGendersHidden"];
  }
  
  if (publicProfileAboutMeModel.IsGenderHidden != nil) {
    [mutDictionary setObject:publicProfileAboutMeModel.IsGenderHidden forKey:@"IsGenderHidden"];
  }
  
  return mutDictionary;
}

@end

