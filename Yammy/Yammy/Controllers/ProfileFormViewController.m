//
//  ProfileFormViewController.m
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileFormViewController.h"
#import "ProfileFormTableViewCell.h"
#import "TitleProfileFormTableViewCell.h"
#import "SliderProfileFormTableViewCell.h"
#import "InterestProfileFormTableViewCell.h"
#import "PopupProfileFormView.h"
#import "ProfileFormQuestionAnswerTableViewCell.h"
#import "UIViewController+ProfileInterface.h"
#import "InterestsMapping.h"
#import "LanguagesViewController.h"
#import "ProfileFormDetailViewController.h"

//static CGFloat const kDefaultHeaderViewHeight = 44.f;
static NSInteger const kTitleProfileFormCellCount = 1;

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
} AboutMeTableViewSections;

typedef enum : NSUInteger {
  NormalSport = 0,
  ExtremeSport,
  Other,
  Music
} TypeInterests;

@interface ProfileFormViewController ()<UITableViewDelegate, UITableViewDataSource, PopupProfileFormViewDelegate, ProfileFormDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *questionsArray;
@property (strong, nonatomic) NSArray *interestsArray;
@property (strong, nonatomic) NSMutableArray *selectedInterestedArray;

@property (strong, nonatomic) PopupProfileFormView *popupProfileFormView;

@end

@implementation ProfileFormViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.questionsArray = @[@"Что для вас Любовь?", @"Что для вас семья?", @"Что для вас секс?"];
  
  if (self.isAboutMe) {
    self.titleLabel.text = nil;
    self.navigationItem.title = @"Общие данные";
  } else {
    self.navigationItem.title = @"Интересы";
    self.titleLabel.attributedText = [self setupTitleLabelByTitle:@"" andDescription:@"Что отличает Вас от других? Чем больше информации вы предоставите, тем быстрее произойдет то, что вы ожидаете от приложения."];
    
    if (self.userInterests.count > 0) {
      self.selectedInterestedArray = [NSMutableArray arrayWithArray:self.userInterests];
    } else {
      self.selectedInterestedArray = [NSMutableArray new];
    }
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] getInterestsWithCompletion:^(NSArray *interestsArray, NSString *errorMessage) {
      [Helpers hideSpinner];
      self.interestsArray = interestsArray;
      [self.tableView reloadData];
    }];
  }
  
  self.layoutTitleLabelHeight.constant = [Helpers sizeOfLabel:self.titleLabel].size.height + 10;
  
  [self updateTableHeaderViewHeight];
  [self prepareBackBarButtonItem];
  
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.tableView reloadData];
}

#pragma mark - Private

- (NSMutableAttributedString *)setupTitleLabelByTitle:(NSString *)title andDescription:(NSString *)description {
  NSMutableAttributedString *titleMutableAttributeString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:17.f]}];
  NSAttributedString *descriptionAttributeString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", description] attributes:@{NSFontAttributeName: [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.f]}];
  [titleMutableAttributeString appendAttributedString:descriptionAttributeString];
  return titleMutableAttributeString;
}

- (void)updateTableHeaderViewHeight {
  UIView *headerView = self.tableView.tableHeaderView;
  CGFloat heightFromHeaderView = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  CGRect frame = headerView.frame;
  frame.size.height = heightFromHeaderView;
  headerView.frame = frame;
  self.tableView.tableHeaderView = headerView;
  [headerView setNeedsLayout];
  [headerView layoutIfNeeded];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.isAboutMe) {
    return MoreTableViewSection + 1;
  } else {
    return 1;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isAboutMe) {
    if (section == QuestionsTableViewSection) {
      return 0;
      //      return self.questionsArray.count;
    } if (section == LanguagesTableViewSection) {
      return 0;
    } else {
      return kTitleProfileFormCellCount;
    }
  } else {
    return self.interestsArray.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == GenderTableViewSection) {
    return 0;
  } else {
    return UITableViewAutomaticDimension;
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == GenderTableViewSection) {
    return 0;
  } else {
    return UITableViewAutomaticDimension;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isAboutMe) {
    if (indexPath.section == RelationsTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Отношения" withAnswerId:self.publicProfileAboutMeModel.RelationshipId withAnswersArray:self.publicProfileAboutMeModel.relationsArray];
    } else if (indexPath.section == GenderTableViewSection) {
      //            ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell =
      //            profileFormQuestionAnswerCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      //            [profileFormQuestionAnswerCell prepareShowHideControlByTag:GenderControlTag];
      return [self setupQuestionCellByQuestion:@"Пол" withAnswerId:self.publicProfileAboutMeModel.SexId withAnswersArray:self.publicProfileAboutMeModel.genders];;
    } else if (indexPath.section == OrientationsTableViewSection) {
      ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self setupQuestionCellByQuestion:@"Ориентация" withAnswerId:self.publicProfileAboutMeModel.GenderId withAnswersArray:self.publicProfileAboutMeModel.orientationsArray];
      profileFormQuestionAnswerCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      [profileFormQuestionAnswerCell prepareShowHideControlByTag:GenderControlTag];
      return profileFormQuestionAnswerCell;
    } else if (indexPath.section == InterestedGendersTableViewSection) {
      ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self setupQuestionCellByQuestion:@"Я ищу" withSelectedAnswersArray:self.publicProfileAboutMeModel.selectedInterestedGenders];
      profileFormQuestionAnswerCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      [profileFormQuestionAnswerCell prepareShowHideControlByTag:InterestedGenderControlTag];
      return profileFormQuestionAnswerCell;
    } else if (indexPath.section == GrowthTableViewSection) {
      ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self setupQuestionCellByQuestion:@"Рост" withAnswer:[self.publicProfileAboutMeModel.Height stringValue]];
      profileFormQuestionAnswerCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      return profileFormQuestionAnswerCell;
    } else if (indexPath.section == WeightTableViewSection) {
      ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self setupQuestionCellByQuestion:@"Вес" withAnswer:[self.publicProfileAboutMeModel.Weight stringValue]];
      profileFormQuestionAnswerCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      return profileFormQuestionAnswerCell;
    } else if (indexPath.section == LiveTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Живу" withAnswerId:self.publicProfileAboutMeModel.LiveWithId withAnswersArray:self.publicProfileAboutMeModel.livesArray];
    } else if (indexPath.section == ChildrenTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Дети" withAnswerId:self.publicProfileAboutMeModel.KidId withAnswersArray:self.publicProfileAboutMeModel.childrenArray];
    } else if (indexPath.section == WorkTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Работа" withAnswerId:self.publicProfileAboutMeModel.JobId withAnswersArray:self.publicProfileAboutMeModel.jobArray];
    } else if (indexPath.section == BodyTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Телосложение" withAnswerId:self.publicProfileAboutMeModel.BodyTypeId withAnswersArray:self.publicProfileAboutMeModel.bodyArray];
    } else if (indexPath.section == SmokingTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Курение" withAnswerId:self.publicProfileAboutMeModel.SmokingId withAnswersArray:self.publicProfileAboutMeModel.smokingArray];
    } else if (indexPath.section == AlchogolTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Алкоголь" withAnswerId:self.publicProfileAboutMeModel.AlcoholId withAnswersArray:self.publicProfileAboutMeModel.alchogolArray];
    } else if (indexPath.section == LanguagesTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Языки" withAnswerId:self.publicProfileAboutMeModel.LanguageId withAnswersArray:self.publicProfileAboutMeModel.languageArray];
    } else if (indexPath.section == QuestionsTableViewSection) {
      return [self setupQuestionTableViewCellByIndexPath:indexPath andArray:self.questionsArray];
    } else if (indexPath.section == MoreTableViewSection) {
      return [self setupQuestionCellByQuestion:@"Характер" withSelectedAnswersArray:self.publicProfileAboutMeModel.selectedTraits];
    } else {
      return [UITableViewCell new];
    }
  } else {
    InterestProfileFormTableViewCell *interestProfileFormCell = [tableView dequeueReusableCellWithIdentifier:kInterestProfileFormCellIdentifier];
    InterestsMapping *mapping = [self.interestsArray objectAtIndex:indexPath.row];
    [interestProfileFormCell prepareInterestProfileCellByMapping:mapping];
    NSArray *filteredArray = [self.selectedInterestedArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Group == %@", mapping.Group]];
    [interestProfileFormCell prepareAnswerByArray:filteredArray];
    return interestProfileFormCell;
  }
}

- (UITableViewCell *)setupQuestionTableViewCellByIndexPath:(NSIndexPath *)indexPath andArray:(NSArray *)array {
  ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileFormQuestionAnswerCellIdentifier];
  NSString *titleFromArray = [array objectAtIndex:indexPath.row];
  
  if (indexPath.row == 0) {
    [profileFormQuestionAnswerCell prepareQuestion:titleFromArray andAnswer:self.publicProfileAboutMeModel.InfoAboutLove];
  } else if (indexPath.row == 1) {
    [profileFormQuestionAnswerCell prepareQuestion:titleFromArray andAnswer:self.publicProfileAboutMeModel.InfoAboutFamily];
  } else {
    [profileFormQuestionAnswerCell prepareQuestion:titleFromArray andAnswer:self.publicProfileAboutMeModel.InfoAboutSex];
  }
  
  return profileFormQuestionAnswerCell;
}

- (ProfileFormQuestionAnswerTableViewCell *)setupQuestionCellByQuestion:(NSString *)question withAnswer:(NSString *)answer {
  ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileFormQuestionAnswerCellIdentifier];
  [profileFormQuestionAnswerCell prepareQuestion:question andAnswer:answer];
  return profileFormQuestionAnswerCell;
}

- (ProfileFormQuestionAnswerTableViewCell *)setupQuestionCellByQuestion:(NSString *)question withAnswerId:(NSNumber *)answerId withAnswersArray:(NSArray *)answersArray {
  ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileFormQuestionAnswerCellIdentifier];
  [profileFormQuestionAnswerCell prepareQuestion:question withAnswerId:answerId andAnswersArray:answersArray];
  return profileFormQuestionAnswerCell;
}

- (ProfileFormQuestionAnswerTableViewCell *)setupQuestionCellByQuestion:(NSString *)question withSelectedAnswersArray:(NSArray *)selectedAnswersArray {
  ProfileFormQuestionAnswerTableViewCell *profileFormQuestionAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileFormQuestionAnswerCellIdentifier];
  [profileFormQuestionAnswerCell prepareQuestion:question withSelectedItemsArray:selectedAnswersArray];
  return profileFormQuestionAnswerCell;
}

- (SliderProfileFormTableViewCell *)setupSliderProfileFormTableViewCellByTitle:(NSString *)title withSize:(CGFloat)size andIsGrowth:(BOOL)isGrowth {
  SliderProfileFormTableViewCell *sliderProfileFormCell = [self.tableView dequeueReusableCellWithIdentifier:kSliderProfileFormCellIdentifier];
  sliderProfileFormCell.isGrowth = isGrowth;
  sliderProfileFormCell.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  [sliderProfileFormCell prepareTitleLabelByTitleText:title];
  [sliderProfileFormCell setupSliderCurrantValue:size];
  return sliderProfileFormCell;
}

- (ProfileFormTableViewCell *)setupProfileFormTableViewCellByObject:(id)object andIndexPath:(NSIndexPath *)indexPath {
  ProfileFormTableViewCell *profileFormCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileFormCellIdentifier];
  profileFormCell.object = object;
  profileFormCell.indexPath = indexPath;
  [profileFormCell prepareSelectedIconByPublicProfileAboutMeModel:self.publicProfileAboutMeModel];
  return profileFormCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isAboutMe) {
    if (indexPath.section == RelationsTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.relationsArray];
    } else if (indexPath.section == GenderTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.genders];
    } else if (indexPath.section == OrientationsTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.orientationsArray];
    } else if (indexPath.section == InterestedGendersTableViewSection) {
      [self presentInterestedGenderPopupProfileFormByIndexPath:indexPath];
    } else if (indexPath.section == GrowthTableViewSection) {
      [self presentSliderByIndexPath:indexPath];
    } else if (indexPath.section == WeightTableViewSection) {
      [self presentSliderByIndexPath:indexPath];
    } else if (indexPath.section == LiveTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.livesArray];
    } else if (indexPath.section == ChildrenTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.childrenArray];
    } else if (indexPath.section == WorkTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.jobArray];
    } else if (indexPath.section == BodyTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.bodyArray];
    } else if (indexPath.section == SmokingTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.smokingArray];
    } else if (indexPath.section == AlchogolTableViewSection) {
      [self presentPopupProfileFormByIndexPath:indexPath andAnswersArray:self.publicProfileAboutMeModel.alchogolArray];
    } else if (indexPath.section == LanguagesTableViewSection) {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Languages" andStoryboardId:LANGUAGES_STORYBOARD_ID];
      LanguagesViewController *languagesVC = (LanguagesViewController *)[navVC topViewController];
      languagesVC.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
      [self.navigationController pushViewController:languagesVC animated:YES];
    } else if (indexPath.section == QuestionsTableViewSection) {
      
      NSString *question = [self.questionsArray objectAtIndex:indexPath.row];
      [self presentAlertByTitle:question andIndexPath:indexPath];
    } else if (indexPath.section == MoreTableViewSection) {
      [self presentCharacterPopupProfileFormByIndexPath:indexPath];
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
  } else {
    [self presentInterestPopupProfileFormByIndexPath:indexPath];
  }
}

- (void)presentPopupProfileFormByIndexPath:(NSIndexPath *)indexPath andAnswersArray:(NSArray *)answersArray {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = YES;
  profileFormDetailVC.indexPath = indexPath;
  profileFormDetailVC.answersArray = answersArray;
  profileFormDetailVC.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (void)presentInterestPopupProfileFormByIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = NO;
  profileFormDetailVC.indexPath = indexPath;
  InterestsMapping *mapping = [self.interestsArray objectAtIndex:indexPath.row];
  profileFormDetailVC.selectedInterests = self.selectedInterestedArray;
  [profileFormDetailVC loadInterestsByMapping:mapping];
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (void)presentCharacterPopupProfileFormByIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = YES;
  profileFormDetailVC.indexPath = indexPath;
  profileFormDetailVC.answersArray = self.publicProfileAboutMeModel.traitArray;
  [profileFormDetailVC loadSelectedTraitsByArray:self.publicProfileAboutMeModel.selectedTraits];
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (void)presentInterestedGenderPopupProfileFormByIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = YES;
  profileFormDetailVC.indexPath = indexPath;
  profileFormDetailVC.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  profileFormDetailVC.answersArray = self.publicProfileAboutMeModel.InterestedGenders;
  [profileFormDetailVC loadSelectedGendersByArray:self.publicProfileAboutMeModel.selectedInterestedGenders];
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (void)presentSliderByIndexPath:(NSIndexPath *)indexPath {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = YES;
  profileFormDetailVC.indexPath = indexPath;
  profileFormDetailVC.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (void)presentAlertByTitle:(NSString *)title andIndexPath:(NSIndexPath *)indexPath {
  NSString *message;
  
  if (indexPath.row == 0) {
    message = self.publicProfileAboutMeModel.InfoAboutLove;
  } else if (indexPath.row == 1) {
    message = self.publicProfileAboutMeModel.InfoAboutFamily;
  } else {
    message = self.publicProfileAboutMeModel.InfoAboutSex;
  }
  
  [UIAlertHelper alertTextField:message title:title placehodelr:nil withOkButton:@"Ок" withCancelButton:@"Отмена" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction, UITextField *textField) {
    if (successAction) {
      if (indexPath.row == 0) {
        self.publicProfileAboutMeModel.InfoAboutLove = textField.text;
      } else if (indexPath.row == 1) {
        self.publicProfileAboutMeModel.InfoAboutFamily = textField.text;
      } else {
        self.publicProfileAboutMeModel.InfoAboutSex = textField.text;
      }
      
      [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }];
}

#pragma mark - Popup Profile Form Delegate

- (void)dismissPopupProfileFormView {
  [Helpers dismissCustomView:self.popupProfileFormView];
}

- (void)selectInterestBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath {
  [self.selectedInterestedArray removeAllObjects];
  [self.selectedInterestedArray addObjectsFromArray:selectedArray];
  [self.tableView reloadData];
}

- (void)selectAnswerBySelectAnswerId:(NSNumber *)answerId andIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == RelationsTableViewSection) {
    self.publicProfileAboutMeModel.RelationshipId = answerId;
  } else if (indexPath.section == GenderTableViewSection) {
    self.publicProfileAboutMeModel.SexId = answerId;
  } else if (indexPath.section == OrientationsTableViewSection) {
    self.publicProfileAboutMeModel.GenderId = answerId;
  } else if (indexPath.section == LiveTableViewSection) {
    self.publicProfileAboutMeModel.LiveWithId = answerId;
  } else if (indexPath.section == ChildrenTableViewSection) {
    self.publicProfileAboutMeModel.KidId = answerId;
  } else if (indexPath.section == WorkTableViewSection) {
    self.publicProfileAboutMeModel.JobId = answerId;
  } else if (indexPath.section == BodyTableViewSection) {
    self.publicProfileAboutMeModel.BodyTypeId = answerId;
  } else if (indexPath.section == SmokingTableViewSection) {
    self.publicProfileAboutMeModel.SmokingId = answerId;
  } else if (indexPath.section == AlchogolTableViewSection) {
    self.publicProfileAboutMeModel.AlcoholId = answerId;
  }
  
  [self.tableView reloadData];
}

- (void)selectCharacterBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath {
  [self.publicProfileAboutMeModel.selectedTraits removeAllObjects];
  [self.publicProfileAboutMeModel.selectedTraits addObjectsFromArray:selectedArray];
  [self.tableView reloadData];
}

- (void)selectInterestedGendersBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath {
  [self.publicProfileAboutMeModel.selectedInterestedGenders removeAllObjects];
  [self.publicProfileAboutMeModel.selectedInterestedGenders addObjectsFromArray:selectedArray];
  [self.tableView reloadData];
}

#pragma mark - Actions

- (void)backButtonDidTap:(id)sender {
  self.publicProfileAboutMeModel = nil;
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(id)sender {
  if (self.delegate != nil) {
    if (self.isAboutMe) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] updateProfileWithParams:[self paramsForUpdateAboutMeWithPublicProfileAboutMeModel:self.publicProfileAboutMeModel] withCompletion:^(BOOL status, NSString *errorMessage) {
        [Helpers hideSpinner];
        [self.delegate reloadAboutMeSection];
      }];
    } else {
      if (self.selectedInterestedArray.count > 0) {
        [Helpers showSpinner];
        NSMutableDictionary *mutDict = [NSMutableDictionary new];
        [mutDict setObject:[Helpers getAccessToken] forKey:@"Token"];
        
        NSMutableString *mutString = [NSMutableString new];
        for (InterestMapping *mapping in self.selectedInterestedArray) {
          NSInteger index = [self.selectedInterestedArray indexOfObject:mapping];
          [mutString appendFormat:@"%@", mapping.IdInterest];
          if (index + 1 != self.selectedInterestedArray.count) {
            [mutString appendString:@","];
          }
        }
        
        [mutDict setObject:mutString forKey:@"Interests"];
        [[ServerManager sharedManager] updateProfileWithParams:mutDict withCompletion:^(BOOL status, NSString *errorMessage) {
          [Helpers hideSpinner];
          [self.delegate reloadAboutMeSection];
        }];
      }
    }
  }
  
  [self.navigationController popViewControllerAnimated:YES];
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

