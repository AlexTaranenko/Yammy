//
//  PopupProfileFormTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PopupProfileFormTableViewCell.h"
#import <GooglePlaces/GooglePlaces.h>
#import "LocationManager.h"

typedef enum : NSUInteger {
  RelationsTableViewSection = 0,
  GendersTableViewSection,
  OrientationsTableViewSection,
  InterestedGendersTableViewSection,
  GrowthTableViewSection,
  WeightTableViewSection,
  LiveTableViewSection,
  ChildrenTableViewSection,
  WorkTableViewSection,
  BodyTableViewSection,
  SmokingTableViewSection,
  AlchogolTableViewSection,
  LanguagesTableViewSection,
  QuestionsTableViewSection,
  MoreTableViewSection
} PopupProfileFormTableViewCellSection;

@interface PopupProfileFormTableViewCell()<UITextFieldDelegate, GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation PopupProfileFormTableViewCell

- (NSDateFormatter *)dateFormatter {
  if (_dateFormatter == nil) {
    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.dateFormat = @"yyyy-MM-dd";
  }
  return _dateFormatter;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareTitleByText:(NSString *)title {
  self.titleLabel.text = title;
}

- (void)prepareSecondTitleByText:(NSString *)secondTitle {
  self.secondTitleLabel.text = secondTitle;
}

- (void)prepareInterestIconImageViewBySelected:(BOOL)selected {
  self.iconImageView.image = [UIImage imageNamed:selected ? @"selected_checkbox" : @"select_checkbox"];
}

- (void)prepareIconImageViewByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel andIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == RelationsTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.RelationshipId];
  } else if (indexPath.section == GendersTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.SexId];
  } else if (indexPath.section == OrientationsTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.GenderId];
  } else if (indexPath.section == LiveTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.LiveWithId];
  } else if (indexPath.section == ChildrenTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.KidId];
  } else if (indexPath.section == WorkTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.JobId];
  } else if (indexPath.section == BodyTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.BodyTypeId];
  } else if (indexPath.section == SmokingTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.SmokingId];
  } else if (indexPath.section == AlchogolTableViewSection) {
    [self compareFirstId:self.dictionaryMapping.IdDictionary toSecondId:publicProfileAboutMeModel.AlcoholId];
  }
}

- (void)compareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId {
  if (secondId != nil && [firstId integerValue] == [secondId integerValue]) {
    self.iconImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  } else {
    self.iconImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  }
}

- (void)disabledIconImageView:(BOOL)disable {
  self.iconImageView.highlighted = NO;
}

- (void)prepareSelectPersonIconImageViewBySelected:(BOOL)selected {
  self.iconImageView.image = [UIImage imageNamed:selected ? @"selected_person_register_icon" : @"select_person_register_icon"];
}

- (void)prepareTextFieldByTag:(NSInteger)tag andText:(NSString *)text andPlaceholder:(NSString *)placeholder {
  self.textField.tag = tag;
  self.textField.text = text;
  self.textField.placeholder = placeholder;
}

- (IBAction)editingChanged:(UITextField *)sender {
  if (sender.tag == 10) {
    self.publicProfileAboutMeModel.FirstName = sender.text;
  }
}

- (IBAction)beginEditing:(UITextField *)sender {
  if (sender.tag == 11) {
    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.timeZone = [NSTimeZone defaultTimeZone];
    picker.date = self.publicProfileAboutMeModel.BirthDate != nil ? [NSDate dateWithTimeIntervalSince1970:[self.publicProfileAboutMeModel.BirthDate doubleValue]] : [self dateFromComponentsByDate:[NSDate date]];
    picker.maximumDate = [self dateFromComponentsByDate:[NSDate date]];
    [picker setDatePickerMode:UIDatePickerModeDate];
    sender.inputView = picker;
    [picker addTarget:self action:@selector(changedDate:) forControlEvents:UIControlEventValueChanged];
  } else if (sender.tag == 12) {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [DELEGATE.window.rootViewController presentViewController:acController animated:YES completion:nil];
    
  } else {
    sender.inputView = nil;
  }
}

- (NSDate *)dateFromComponentsByDate:(NSDate *)date {
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  [components setYear:[components year] - 18];
  [components setMonth:[components month]];
  [components setDay:[components day]];
  return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (void)changedDate:(UIDatePicker *)datepicker {
  self.publicProfileAboutMeModel.BirthDate = @([datepicker.date timeIntervalSince1970]);
  self.textField.text = [self.dateFormatter stringFromDate:datepicker.date];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
  [viewController dismissViewControllerAnimated:YES completion:nil];
  if (self.searchModel) {
    self.searchModel.City = place.name;
    self.textField.text = self.searchModel.City;
    self.searchModel.Latitude = @(place.coordinate.latitude);
    self.searchModel.Longitude = @(place.coordinate.longitude);
  } else {
    self.publicProfileAboutMeModel.City = place.name;
    if (place.addressComponents.count > 0) {
      for (GMSAddressComponent *component in place.addressComponents) {
        if ([component.type isEqualToString:@"country"]) {
          self.publicProfileAboutMeModel.Country = component.name;
          break;
        }
      }
    }
    self.textField.text = self.publicProfileAboutMeModel.City;
    [LocationManager sharedManager].location = [[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
  }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [viewController dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [viewController dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end

