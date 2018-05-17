//
//  ProfileFormDetailViewController.m
//  Yammy
//
//  Created by Alex on 3/20/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ProfileFormDetailViewController.h"
#import "PopupProfileFormTableViewCell.h"
#import <CMSwitchView/CMSwitchView.h>
#import "ProfileFormDetailSliderTableViewCell.h"
#import "DetailProfileFormSectionView.h"
#import "UIViewController+ProfileInterface.h"
#import "LocationManager.h"

typedef enum : NSUInteger {
  RelationsTableViewSection = 0,
  GenderTableViewSection,
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
} ProfileFormDetailAboutMe;

typedef enum : NSUInteger {
  NormalSport = 0,
  ExtremeSport,
  Other,
  Music
} ProfileFormDetailInterests;

typedef enum : NSUInteger {
  TotalInfoSection = 0,
  PrivateInterestsSection,
} ProfileFormDetailPrivateSections;


@interface ProfileFormDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CMSwitchViewDelegate, ProfileFormDetailSliderTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *switchContainerView;
@property (weak, nonatomic) IBOutlet UILabel *footerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *footerDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *containerSwitchView;
@property (weak, nonatomic) IBOutlet UIView *containerOkButtonView;
@property (weak, nonatomic) IBOutlet UILabel *sexMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *containerSexMessageView;

@property (strong, nonatomic) NSArray *interestsArray;
@property (strong, nonatomic) NSNumber *selectAnswerId;

@property (strong, nonatomic) InterestMapping *mapping;
@property (strong, nonatomic) DictionaryMapping *characterDictionaryMapping;
@property (strong, nonatomic) DictionaryMapping *genderDictionaryMapping;

@property (strong, nonatomic) NSMutableArray *addedInterests;

@property (strong, nonatomic) NSMutableArray *addedTraits;

@property (strong, nonatomic) NSMutableArray *addedInterestedGenders;

@property (strong, nonatomic) CMSwitchView *switchView;

@property (strong, nonatomic) NSString *answer;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation ProfileFormDetailViewController

- (NSNumberFormatter *)numberFormatter {
  if (_numberFormatter == nil) {
    _numberFormatter = [NSNumberFormatter new];
    _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  }
  return _numberFormatter;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.selectAnswerId = nil;
  self.containerOkButtonView.hidden = YES;
  self.containerSexMessageView.hidden = YES;
  
  if (self.isMyName) {
    self.selectAnswerId = self.publicProfileAboutMeModel.SexId;
    self.containerOkButtonView.hidden = NO;
    if (self.publicProfileAboutMeModel.SexId != nil) {
      self.sexMessageLabel.text = @"Если вы ошиблись при выборе пола - обратитесь в службу поддержки";
    } else {
      self.sexMessageLabel.text = nil;
    }
  }
  
  if (self.isAboutMe) {
    self.navigationItem.title = @"Общие данные";
  } else {
    self.navigationItem.title = @"Интересы";
  }
  
  if (self.myPrivateProfileQuestionModel) {
    self.answer = self.myPrivateProfileQuestionModel.answer;
    self.containerSwitchView.hidden = YES;
  } else {
    if (self.indexPath.section == OrientationsTableViewSection ||
        self.indexPath.section == InterestedGendersTableViewSection) {
      self.containerSwitchView.hidden = NO;
      [self prepareSwitch];
    } else {
      if (self.indexPath.section == GenderTableViewSection) {
        if (self.publicProfileAboutMeModel.SexId != nil) {
          self.containerSexMessageView.hidden = NO;
        }
      }
      self.containerSwitchView.hidden = YES;
    }
  }
  
  [self prepareTitleLabel];
  
  if (self.isAboutMe) {
    if (self.indexPath.section == MoreTableViewSection) {
      [self prepareBackBarButtonItem];
    } else {
      if (self.publicProfileAboutMeModel.FirstName.length != 0) {
        [self prepareBackBarButtonItem];
      } else if (self.myPrivateProfileQuestionModel) {
        [self prepareBackBarButtonItem];
      }
      else {
        self.navigationItem.hidesBackButton = YES;
      }
    }
  } else {
    [self prepareBackBarButtonItem];
  }
  
  [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormTextFieldCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormTextFieldCellIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)prepareSwitch {
  self.switchView = [[CMSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.switchContainerView.frame.size.width, self.switchContainerView.frame.size.height)];
  self.switchView.dotColor = RGB(249, 0, 64);
  self.switchView.color = [UIColor whiteColor];
  self.switchView.tintColor = [UIColor whiteColor];
  self.switchView.dotWeight = 24.f;
  self.switchView.delegate = self;
  [self.switchContainerView addSubview:self.switchView];
  
  if (self.indexPath.section == OrientationsTableViewSection) {
    [self.switchView setSelected:[self.publicProfileAboutMeModel.IsGenderHidden boolValue] animated:YES];
    [self changeSwitchColorByIsOn:[self.publicProfileAboutMeModel.IsGenderHidden boolValue]];
  } else {
    [self.switchView setSelected:[self.publicProfileAboutMeModel.IsInterestedGendersHidden boolValue] animated:YES];
    [self changeSwitchColorByIsOn:[self.publicProfileAboutMeModel.IsInterestedGendersHidden boolValue]];
  }
  
  self.footerTitleLabel.text = self.indexPath.section == OrientationsTableViewSection ? @"Скрыть предпочтения" : @"Скрыть интересы";
  self.self.footerDescriptionLabel.text = self.indexPath.section == OrientationsTableViewSection ? @"Ваши сексуальные предпочтения видны только вам" : @"Ваши интересы видны только вам";
}

- (void)changeSwitchColorByIsOn:(BOOL)isOn {
  self.switchView.dotColor = isOn ? RGB(249, 0, 64) : RGB(237, 237, 237);
  if (self.indexPath.section == OrientationsTableViewSection) {
    self.publicProfileAboutMeModel.IsGenderHidden = @(isOn);
  } else {
    self.publicProfileAboutMeModel.IsInterestedGendersHidden = @(isOn);
  }
}

- (void)prepareTitleLabel {
  if (self.myPrivateProfileQuestionModel) {
    self.titleLabel.text = self.myPrivateProfileQuestionModel.question;
  } else {
    if (self.isAboutMe) {
      if (self.isMyName) {
        self.titleLabel.text = @"";
      } else {
        switch (self.indexPath.section) {
          case RelationsTableViewSection: self.titleLabel.text = @"Отношения"; break;
          case GenderTableViewSection: self.titleLabel.text = @"Пол"; break;
          case OrientationsTableViewSection: self.titleLabel.text = @"Ориентация"; break;
          case InterestedGendersTableViewSection: self.titleLabel.text = @"Я ищу"; break;
          case GrowthTableViewSection: self.titleLabel.text = @"Рост"; break;
          case WeightTableViewSection: self.titleLabel.text = @"Вес"; break;
          case LiveTableViewSection: self.titleLabel.text = @"Живу"; break;
          case ChildrenTableViewSection: self.titleLabel.text = @"Дети"; break;
          case WorkTableViewSection: self.titleLabel.text = @"Работа"; break;
          case BodyTableViewSection: self.titleLabel.text = @"Телосложение"; break;
          case SmokingTableViewSection: self.titleLabel.text = @"Курение"; break;
          case AlchogolTableViewSection: self.titleLabel.text = @"Алкоголь"; break;
          case LanguagesTableViewSection: self.titleLabel.text = @"Языки"; break;
          case MoreTableViewSection: self.titleLabel.text = @"Характер"; break;
          default: self.titleLabel.text = @""; break;
        }
      }
    } else {
      switch (self.indexPath.section) {
        case NormalSport: self.titleLabel.text = @"Спорт"; break;
        case ExtremeSport: self.titleLabel.text = @"Экстрим"; break;
        case Other: self.titleLabel.text = @"Разное"; break;
        case Music: self.titleLabel.text = @"Музыка"; break;
        default:
          break;
      }
    }
  }
}

- (void)loadInterestsByMapping:(InterestsMapping *)interestsMapping {
  self.interestsArray = interestsMapping.Items;
  self.addedInterests = [NSMutableArray new];
  [self.addedInterests addObjectsFromArray:self.selectedInterests];
  [self.tableView reloadData];
}

- (void)loadSelectedTraitsByArray:(NSArray *)selectedTraits {
  self.addedTraits = [NSMutableArray new];
  [self.addedTraits addObjectsFromArray:selectedTraits];
  [self.tableView reloadData];
}

- (void)loadSelectedGendersByArray:(NSArray *)selectedGenders {
  self.addedInterestedGenders = [NSMutableArray new];
  [self.addedInterestedGenders addObjectsFromArray:selectedGenders];
  [self.tableView reloadData];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.isMyName) {
    if (self.publicProfileAboutMeModel.Latitude != nil && self.publicProfileAboutMeModel.Longitude) {
      return 4;
    } else {
      return 3;
    }
  } else {
    return 1;
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isMyName) {
    if (self.publicProfileAboutMeModel.Latitude != nil && self.publicProfileAboutMeModel.Longitude) {
      if (section == 0 || section == 1 || section == 2) {
        return 1;
      } else {
        return 2;
      }
    } else {
      if (section == 0 || section == 1) {
        return 1;
      } else {
        return 2;
      }
    }
  } else {
    if (self.myPrivateProfileQuestionModel) {
      return self.answersArray.count;
    } else {
      if (self.indexPath.section == GrowthTableViewSection || self.indexPath.section == WeightTableViewSection) {
        return 1;
      } else if (self.answersArray.count > 0) {
        return self.answersArray.count;
      } else {
        if (self.interestsArray != nil) {
          return self.interestsArray.count;
        } else {
          return 0;
        }
      }
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.isMyName ? 41.f : 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return self.isMyName ? 41.f : 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.isMyName) {
    if (self.publicProfileAboutMeModel.Latitude != nil && self.publicProfileAboutMeModel.Longitude) {
      if (section == 0) {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Ваше имя"];
      } else if (section == 1) {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Возраст"];
      } else if (section == 2) {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Местоположение"];
      } else {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Пол"];
      }
    } else {
      if (section == 0) {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Ваше имя"];
      } else if (section == 1) {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Возраст"];
      } else {
        return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Пол"];
      }
    }
  } else {
    return nil;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isMyName) {
    if (self.publicProfileAboutMeModel.Latitude != nil && self.publicProfileAboutMeModel.Longitude) {
      if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
        if (indexPath.section == 0) {
          return [self prepareMyNamePopupProfileFormTableViewCellByIndexPath:indexPath];
        } else if (indexPath.section == 1) {
          return [self preparMyBirthdayPopupProfileFormTableViewCellByIndexPath:indexPath];
        } else {
          PopupProfileFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormTextFieldCellIdentifier];
          cell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
          [cell prepareTextFieldByTag:10 + indexPath.section andText:self.publicProfileAboutMeModel.City andPlaceholder:@"Местоположение"];
          return cell;
        }
      } else {
        return [self prepareMyGenderPopupProfileFormTableViewCellByIndexPath:indexPath];
      }
    } else {
      if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 0) {
          return [self prepareMyNamePopupProfileFormTableViewCellByIndexPath:indexPath];
        } else {
          return [self preparMyBirthdayPopupProfileFormTableViewCellByIndexPath:indexPath];
        }
      } else {
        return [self prepareMyGenderPopupProfileFormTableViewCellByIndexPath:indexPath];
      }
    }
  } else {
    if (self.myPrivateProfileQuestionModel) {
      if (self.myPrivateProfileQuestionModel.answerType == SliderAnswerType) {
        ProfileFormDetailSliderTableViewCell *profileFormDetailSliderCell = [tableView dequeueReusableCellWithIdentifier:kProfileFormDetailSliderCellIdentifier];
        profileFormDetailSliderCell.delegate = self;
        profileFormDetailSliderCell.value = [self.numberFormatter numberFromString:self.myPrivateProfileQuestionModel.answer];
        
        if ([ServerManager sharedManager].myProfileMapping.SexId != nil && [[ServerManager sharedManager].myProfileMapping.SexId integerValue] == 1) {
          [profileFormDetailSliderCell setupPrivateSlider:YES];
        } else {
          [profileFormDetailSliderCell setupPrivateSlider:NO];
        }
        
        return profileFormDetailSliderCell;
      } else {
        PopupProfileFormTableViewCell *popupProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
        DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
        popupProfileFormCell.dictionaryMapping = dictionaryMapping;
        [popupProfileFormCell prepareSecondTitleByText:dictionaryMapping.Title];
        if (self.answer != nil) {
          if ([self.answer isEqualToString:dictionaryMapping.Title]) {
            [popupProfileFormCell prepareSelectPersonIconImageViewBySelected:YES];
          } else {
            [popupProfileFormCell prepareSelectPersonIconImageViewBySelected:NO];
          }
        } else {
          [popupProfileFormCell prepareSelectPersonIconImageViewBySelected:NO];
        }
        return popupProfileFormCell;
      }
    } else {
      if (self.indexPath.section == GrowthTableViewSection || self.indexPath.section == WeightTableViewSection) {
        ProfileFormDetailSliderTableViewCell *profileFormDetailSliderCell = [tableView dequeueReusableCellWithIdentifier:kProfileFormDetailSliderCellIdentifier];
        profileFormDetailSliderCell.delegate = self;
        if (self.indexPath.section == GrowthTableViewSection) {
          profileFormDetailSliderCell.value = self.publicProfileAboutMeModel.Height;
          [profileFormDetailSliderCell setupSlider:YES];
        } else {
          profileFormDetailSliderCell.value = self.publicProfileAboutMeModel.Weight;
          [profileFormDetailSliderCell setupSlider:NO];
        }
        return profileFormDetailSliderCell;
      } else {
        PopupProfileFormTableViewCell *popupProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
        
        if (self.answersArray.count > 0) {
          DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
          popupProfileFormCell.dictionaryMapping = dictionaryMapping;
          if (self.selectAnswerId != nil) {
            [popupProfileFormCell compareFirstId:dictionaryMapping.IdDictionary toSecondId:self.selectAnswerId];
          } else {
            if (self.addedTraits != nil) {
              [self preparePopupProfileFormTableViewCellByIndexPath:indexPath andAddedArray:self.addedTraits andCell:popupProfileFormCell];
            } else if (self.addedInterestedGenders != nil) {
              [self preparePopupProfileFormTableViewCellByIndexPath:indexPath andAddedArray:self.addedInterestedGenders andCell:popupProfileFormCell];
            } else {
              if (self.indexPath.section == GenderTableViewSection) {
                if (self.publicProfileAboutMeModel.SexId == nil) {
                  popupProfileFormCell.userInteractionEnabled = YES;
                } else {
                  popupProfileFormCell.userInteractionEnabled = NO;
                }
              }
              [popupProfileFormCell prepareIconImageViewByPublicProfileAboutMeModel:self.publicProfileAboutMeModel andIndexPath:self.indexPath];
            }
          }
          
          [popupProfileFormCell prepareSecondTitleByText:dictionaryMapping.Title];
        } else {
          PopupProfileFormTableViewCell *popupProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
          InterestMapping *mapping = [self.interestsArray objectAtIndex:indexPath.row];
          NSArray *filteredArray = [self.addedInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdInterest == %@", mapping.IdInterest]];
          [popupProfileFormCell prepareInterestIconImageViewBySelected:filteredArray.count > 0 ? YES : NO];
          [popupProfileFormCell prepareSecondTitleByText:mapping.Title];
          return popupProfileFormCell;
        }
        
        return popupProfileFormCell;
      }
    }
  }
}

- (PopupProfileFormTableViewCell *)prepareMyGenderPopupProfileFormTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  PopupProfileFormTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
  DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
  [cell prepareSecondTitleByText:dictionaryMapping.Title];
  if (self.selectAnswerId != nil) {
    [cell compareFirstId:dictionaryMapping.IdDictionary toSecondId:self.selectAnswerId];
  }
  
  if (self.publicProfileAboutMeModel.SexId == nil) {
    cell.userInteractionEnabled = YES;
  } else {
    cell.userInteractionEnabled = NO;
  }
  
  return cell;
}

- (PopupProfileFormTableViewCell *)prepareMyNamePopupProfileFormTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  PopupProfileFormTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPopupProfileFormTextFieldCellIdentifier];
  cell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  [cell prepareTextFieldByTag:10 + indexPath.section andText:self.publicProfileAboutMeModel.FirstName andPlaceholder:@"Ваше имя"];
  return cell;
}

- (PopupProfileFormTableViewCell *)preparMyBirthdayPopupProfileFormTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  PopupProfileFormTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPopupProfileFormTextFieldCellIdentifier];
  cell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  if (self.publicProfileAboutMeModel.BirthDate != nil) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    [cell prepareTextFieldByTag:10 + indexPath.section andText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self.publicProfileAboutMeModel.BirthDate doubleValue]]] andPlaceholder:@"Возраст"];
  } else {
    [cell prepareTextFieldByTag:10 + indexPath.section andText:nil andPlaceholder:@"Возраст"];
  }
  return cell;
}

- (void)preparePopupProfileFormTableViewCellByIndexPath:(NSIndexPath *)indexPath andAddedArray:(NSArray *)addedArray andCell:(PopupProfileFormTableViewCell *)cell {
  DictionaryMapping *mapping = [self.answersArray objectAtIndex:indexPath.row];
  NSArray *filteredArray = [addedArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
  [cell prepareInterestIconImageViewBySelected:filteredArray.count > 0 ? YES : NO];
  [cell prepareSecondTitleByText:mapping.Title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isMyName) {
    if (self.publicProfileAboutMeModel.Latitude != nil && self.publicProfileAboutMeModel.Longitude) {
      if (indexPath.section == 3) {
        [self selectGenderByIndexPath:indexPath];
      }
    } else {
      if (indexPath.section == 2) {
        [self selectGenderByIndexPath:indexPath];
      }
    }
  } else {
    if (self.myPrivateProfileQuestionModel) {
      DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
      self.answer = dictionaryMapping.Title;
      [self.tableView reloadData];
      
    } else {
      if (self.answersArray.count > 0) {
        if (self.addedTraits != nil) {
          self.characterDictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
          NSArray *filteredArray = [self.addedTraits filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", self.characterDictionaryMapping.IdDictionary]];
          if (filteredArray.count > 0) {
            DictionaryMapping *mapping = [filteredArray firstObject];
            NSInteger index = [self.addedTraits indexOfObject:mapping];
            [self.addedTraits removeObjectAtIndex:index];
          } else {
            [self.addedTraits addObject:self.characterDictionaryMapping];
          }
          
          [self.tableView reloadData];
        } else if (self.addedInterestedGenders != nil) {
          self.genderDictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
          NSArray *filteredArray = [self.addedInterestedGenders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", self.genderDictionaryMapping.IdDictionary]];
          if (filteredArray.count > 0) {
            DictionaryMapping *mapping = [filteredArray firstObject];
            NSInteger index = [self.addedInterestedGenders indexOfObject:mapping];
            [self.addedInterestedGenders removeObjectAtIndex:index];
          } else {
            [self.addedInterestedGenders addObject:self.genderDictionaryMapping];
          }
          
          [self.tableView reloadData];
        } else {
          [self selectGenderByIndexPath:indexPath];
        }
      } else {
        self.mapping = [self.interestsArray objectAtIndex:indexPath.row];
        
        NSArray *filteredArray = [self.addedInterests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdInterest == %@", self.mapping.IdInterest]];
        if (filteredArray.count > 0) {
          InterestMapping *mapping = [filteredArray firstObject];
          NSInteger index = [self.addedInterests indexOfObject:mapping];
          [self.addedInterests removeObjectAtIndex:index];
        } else {
          [self.addedInterests addObject:self.mapping];
        }
        
        [self.tableView reloadData];
      }
    }
  }
}

- (void)selectGenderByIndexPath:(NSIndexPath *)indexPath {
  if (self.indexPath.section == GenderTableViewSection) {
    if (self.publicProfileAboutMeModel.SexId == nil) {
      [self selectAnswerByIndexPath:indexPath];
    } else {
      [WToast showWithText:@"Если вы ошиблись при выборе пола - обратитесь в службу поддержки" duration:5.0];
    }
  } else {
    [self selectAnswerByIndexPath:indexPath];
  }
}

- (void)selectAnswerByIndexPath:(NSIndexPath *)indexPath {
  DictionaryMapping *dictionaryMapping = [self.answersArray objectAtIndex:indexPath.row];
  self.selectAnswerId = dictionaryMapping.IdDictionary;
  [self.tableView reloadData];
}

#pragma mark - Delegate

- (void)saveResultValue:(NSNumber *)value {
  if (self.myPrivateProfileQuestionModel) {
    self.myPrivateProfileQuestionModel.answer = [NSString stringWithFormat:@"%ld", (long)[value integerValue]];
    
    if (self.delegate != nil) {
      [self.delegate reloadTableViewBySelectIndexPath:self.indexPath];
    }
  } else {
    if (self.indexPath.section == GrowthTableViewSection) {
      self.publicProfileAboutMeModel.Height = @([value integerValue]);
    } else {
      self.publicProfileAboutMeModel.Weight= @([value integerValue]);
    }
  }
  
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Switch

- (void)switchValueChanged:(id)sender andNewValue:(BOOL)value {
  [self changeSwitchColorByIsOn:value];
}

#pragma mark - Action

- (void)backButtonDidTap:(id)sender {
  if (!self.isMyName) {
    if (self.myPrivateProfileQuestionModel) {
      self.myPrivateProfileQuestionModel.answer = self.answer;
      if (self.delegate != nil) {
        [self.delegate reloadTableViewBySelectIndexPath:self.indexPath];
      }
    } else {
      if (self.delegate != nil) {
        if (self.answersArray.count > 0 && self.selectAnswerId != nil) {
          [self.delegate selectAnswerBySelectAnswerId:self.selectAnswerId andIndexPath:self.indexPath];
        } else if (self.answersArray.count > 0 && self.addedTraits != nil) {
          [self.delegate selectCharacterBySelectedArray:[self.addedTraits copy] andIndexPath:self.indexPath];
        } else if (self.answersArray.count > 0 && self.addedInterestedGenders != nil) {
          [self.delegate selectInterestedGendersBySelectedArray:[self.addedInterestedGenders copy] andIndexPath:self.indexPath];
        } else {
          [self.delegate selectInterestBySelectedArray:[self.addedInterests copy] andIndexPath:self.indexPath];
        }
      }
    }
  }
  
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)okDidTap:(CustomButton *)sender {
  if (self.publicProfileAboutMeModel.FirstName.length == 0) {
    [WToast showWithText:@"Введите свое имя" duration:5.0];
    return;
  }
  
  if (self.delegate != nil) {
    if ([LocationManager sharedManager].location != nil) {
      self.publicProfileAboutMeModel.Latitude = @([LocationManager sharedManager].location.coordinate.latitude);
      self.publicProfileAboutMeModel.Longitude = @([LocationManager sharedManager].location.coordinate.longitude);
    }
    
    self.publicProfileAboutMeModel.SexId = self.selectAnswerId;
    [self.delegate updatePublicProfileByPublicProfileAboutMeModel:self.publicProfileAboutMeModel];
  }
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.navigationController popViewControllerAnimated:YES];
  });
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
