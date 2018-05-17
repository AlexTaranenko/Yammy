//
//  SearchPrivateViewController.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SearchPrivateViewController.h"
#import "InterestMeRegisterTableViewCell.h"
#import "CoincidenceSearchPrivateTableViewCell.h"
#import "OrientationRegisterTableViewCell.h"
#import "AgeSearchTableViewCell.h"
#import "CountrySearchTableViewCell.h"

typedef enum : NSUInteger {
  CoincidenceSearchPrivateSection = 0,
  InterestPersonSearchPrivateSection,
  AgeSearchPrivateSection,
  LocationSearchPrivateSection
} SearchPrivateSections;

static NSInteger kSearchPrivateSections = 4;

@interface SearchPrivateViewController ()<UITableViewDelegate, UITableViewDataSource, CountrySearchTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *orientationsArray;

@property (strong, nonatomic) NSArray *countriesArray;

@end

@implementation SearchPrivateViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self prepareBackBarButtonItem];
  
  dispatch_group_t group = dispatch_group_create();
  [Helpers showSpinner];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getLocationListWithCompletion:^(NSArray *locationArray, NSString *errorMessage) {
    if (locationArray) {
      self.countriesArray = locationArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getGenderListForInterestedIn:YES withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.orientationsArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [Helpers hideSpinner];
    [self.tableView reloadData];
  });
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == CoincidenceSearchPrivateSection ? 3.f : 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return section == CoincidenceSearchPrivateSection ? 3.f : 20.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *sectionView = [UIView new];
  if (section == CoincidenceSearchPrivateSection) {
    [sectionView setBackgroundColor:[UIColor whiteColor]];
  } else {
    [sectionView setBackgroundColor:RGB(235, 235, 235)];
  }
  return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kSearchPrivateSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == CoincidenceSearchPrivateSection) {
    return 2;
  } else if (section == InterestPersonSearchPrivateSection) {
    return 1 + self.orientationsArray.count;
  } else if (section == AgeSearchPrivateSection) {
    return 1;
  } else if (section == LocationSearchPrivateSection) {
    return 1 + self.countriesArray.count;
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == CoincidenceSearchPrivateSection) {
    if (indexPath.row == 0) {
      return [self prepareInterestMeRegisterTableViewCellByIndexPath:indexPath andTitle:@"Совпадение"];
    } else {
      CoincidenceSearchPrivateTableViewCell *coincidenceSearchPrivateCell = [tableView dequeueReusableCellWithIdentifier:@"coincidenceSearchPrivateCell"];
      coincidenceSearchPrivateCell.searchPrivateModel = self.searchPrivateModel;
      [coincidenceSearchPrivateCell prepareShowingButtonsBySearchPrivateModel:self.searchPrivateModel];
      return coincidenceSearchPrivateCell;
    }
  } else if (indexPath.section == InterestPersonSearchPrivateSection) {
    if (indexPath.row == 0) {
      return [self prepareInterestMeRegisterTableViewCellByIndexPath:indexPath andTitle:@"Меня интересует"];
    } else {
      OrientationRegisterTableViewCell *orientationRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"orientationRegisterTableCell"];
      DictionaryMapping *mapping = [self.orientationsArray objectAtIndex:indexPath.row - 1];
      [orientationRegisterTableCell prepareNameByGenderMapping:mapping];
      if (self.searchPrivateModel.genderId == mapping.IdDictionary) {
        [orientationRegisterTableCell selectedCheckBoxImageView:YES];
      } else {
        [orientationRegisterTableCell selectedCheckBoxImageView:NO];
      }
      return orientationRegisterTableCell;
    }
  } else if (indexPath.section == AgeSearchPrivateSection) {
    AgeSearchTableViewCell *ageSearchCell = [tableView dequeueReusableCellWithIdentifier:@"ageSearchCell"];
    ageSearchCell.searchPrivateModel = self.searchPrivateModel;
    [ageSearchCell prepareRangeSliderBySearchPrivateModel:self.searchPrivateModel];
    return ageSearchCell;
  } else if (indexPath.section == LocationSearchPrivateSection) {
    if (indexPath.row == 0) {
      return [self prepareInterestMeRegisterTableViewCellByIndexPath:indexPath andTitle:@"Местоположение"];
    } else {
      CountrySearchTableViewCell *countrySearchCell = [tableView dequeueReusableCellWithIdentifier:@"countrySearchCell"];
      countrySearchCell.delegate = self;
      
      CountryMapping *countryMapping = [self.countriesArray objectAtIndex:indexPath.row - 1];
      countrySearchCell.titleText = countryMapping.Title;
      NSArray *filteredArray = [self.searchPrivateModel filteredCountriesArrayByIdLocation:countryMapping.IdLocation];
      [countrySearchCell selectedIconImageView:filteredArray.count > 0 ? YES : NO];
      return countrySearchCell;
    }
  } else {
    return [UITableViewCell new];
  }
}

- (InterestMeRegisterTableViewCell *)prepareInterestMeRegisterTableViewCellByIndexPath:(NSIndexPath *)indexPath andTitle:(NSString *)title {
  InterestMeRegisterTableViewCell *interestMeRegisterTableCell = [self.tableView dequeueReusableCellWithIdentifier:@"interestMeRegisterTableCell"];
  if (indexPath.section != LocationSearchPrivateSection || indexPath.section != InterestPersonSearchPrivateSection) {
    interestMeRegisterTableCell.separatorInset = UIEdgeInsetsMake(0, self.tableView.frame.size.width, 0, 0);
  }
  interestMeRegisterTableCell.titleText = title;
  return interestMeRegisterTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == InterestPersonSearchPrivateSection) {
    if (indexPath.row != 0) {
      [self.searchPrivateModel selectOrientationByIndexPath:indexPath];
      [tableView reloadSections:[NSIndexSet indexSetWithIndex:InterestPersonSearchPrivateSection] withRowAnimation:UITableViewRowAnimationNone];
    }
  } else if (indexPath.section == LocationSearchPrivateSection) {
    if (indexPath.row != 0) {
      CountryMapping *countryMapping = [self.countriesArray objectAtIndex:indexPath.row - 1];
      [self.searchPrivateModel selectCountryByIdLocation:countryMapping.IdLocation];
      [tableView reloadSections:[NSIndexSet indexSetWithIndex:LocationSearchPrivateSection] withRowAnimation:UITableViewRowAnimationNone];
    }
  }
}

#pragma mark - Delegate

- (void)selectLocationByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  CountryMapping *countryMapping = [self.countriesArray objectAtIndex:indexPath.row - 1];
  [self.searchPrivateModel selectCountryByIdLocation:countryMapping.IdLocation];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:LocationSearchPrivateSection] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Action

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(UIButton *)sender {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  if (self.searchPrivateModel.genderId != nil) {
    [mutDict setObject:self.searchPrivateModel.genderId forKey:@"GenderId"];
  }
  
  [mutDict setObject:self.searchPrivateModel.minAge forKey:@"AgeMin"];
  [mutDict setObject:self.searchPrivateModel.maxAge forKey:@"AgeMax"];
  
  if ([self.searchPrivateModel.coincidenceUsers integerValue] == 10) {
    [mutDict setObject:@(1) forKey:@"MatchMax"];
  } else {
    [mutDict setObject:@(0) forKey:@"MatchMax"];
  }
  
  if (self.searchPrivateModel.countriesArray.count > 0) {
    NSString *locationString = [self prepareMutableStringByArray:self.searchPrivateModel.countriesArray];
    [mutDict setObject:locationString forKey:@"Locations"];
  } else {
    [mutDict setObject:@"" forKey:@"Locations"];
  }
  
  if (self.searchPrivateModel.preferencesArray.count > 0) {
    NSString *preferenceString = [self preparePreferencesMutableStringByArray:self.searchPrivateModel.preferencesArray];
    [mutDict setObject:preferenceString forKey:@"PrivatePreferences"];
  } else {
    [mutDict setObject:@"" forKey:@"PrivatePreferences"];
  }
  
  [self.searchPrivateModel saveParamsWithSearchPrivateModel:self.searchPrivateModel];
  
  if (self.delegate != nil) {
    [self.delegate privateSearchByParams:mutDict];
  }
  
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSString *)prepareMutableStringByArray:(NSArray *)array {
  NSMutableString *mutString = [NSMutableString new];
  for (NSNumber *locationId in array) {
    NSInteger index = [array indexOfObject:locationId];
    [mutString appendString:[locationId stringValue]];
    if (index + 1 != array.count) {
      [mutString appendString:@","];
    }
  }
  
  return mutString;
}

- (NSString *)preparePreferencesMutableStringByArray:(NSArray *)array {
  NSMutableString *mutString = [NSMutableString new];
  for (PreferencesMapping *mapping in array) {
    NSInteger index = [array indexOfObject:mapping];
    [mutString appendString:[mapping.IdPreferences stringValue]];
    if (index + 1 != array.count) {
      [mutString appendString:@","];
    }
  }
  
  return mutString;
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

