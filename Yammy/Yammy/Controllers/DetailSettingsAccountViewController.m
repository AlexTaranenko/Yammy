//
//  DetailSettingsAccountViewController.m
//  Yammy
//
//  Created by Alex on 2/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "DetailSettingsAccountViewController.h"
#import "DetailSettingsTableViewCell.h"
#import "DetailSettingsModel.h"
#import "LanguagesViewController.h"
#import "ProfileFormTableViewCell.h"
#import "CustomAlertView.h"
#import "MotivationTranslatorPopupView.h"

static const NSInteger kSocialRow = 1;
static const NSInteger kClearRow = 1;
static const NSInteger kLocationRow = 1;

@interface DetailSettingsAccountViewController ()<UITableViewDelegate, UITableViewDataSource, DetailSettingsTableViewCellDelegate, LanguagesViewControllerDelegate, ProfileFormTableViewCellDelegate, MotivationTranslatorPopupViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutDeleteContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *headerTableView;
@property (weak, nonatomic) IBOutlet UIView *footerTableView;
@property (weak, nonatomic) IBOutlet UIButton *deleteProfileButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSArray *itemsArray;
@property (assign, nonatomic) BOOL isOffAll;
@property (strong, nonatomic) NSArray *addedLanguages;
@property (assign, nonatomic) BOOL isCurrentVC;
@property (strong, nonatomic) MotivationTranslatorPopupView *motivationTranslatorPopupView;

@end

@implementation DetailSettingsAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  
//  self.isOffAll = [self checkIsOnAllNotifications];
  [self setupItemsArray];
  
  [self prepareBackBarButtonItem];
  
  if (self.detailSettingsAccountRow == LanguageDetailRow && [self.userSettingsMapping.TranslateChats boolValue] == false) {
    [self showMotivationTranslatorPopupView];
  }
  
  if (self.detailSettingsAccountRow != LanguageDetailRow) {
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView = nil;
  }
  
  if (self.detailSettingsAccountRow != DeleteProfileDetailRow) {
    self.layoutDeleteContainerHeight.constant = 0;
  }
  
  if (self.detailSettingsAccountRow == VerificationDetailRow) {
    [[ServerManager sharedManager] userSettingsVerifications];
  }
  
  if (self.detailSettingsAccountRow == DeleteProfileDetailRow) {
    [self loadData];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self checkCurrentVC:YES];
  [self loadUserLanguagesFromServer:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [self checkCurrentVC:NO];
}

#pragma mark - Private

- (void)showMotivationTranslatorPopupView {
  self.motivationTranslatorPopupView = [MotivationTranslatorPopupView createMotivationTranslatorPopupView];
  self.motivationTranslatorPopupView.delegate = self;
  [Helpers showCustomView:self.motivationTranslatorPopupView];
}

- (void)loadData {
  [[ServerManager sharedManager] getUserSettingsWithCompletion:^(UserSettingsMapping *userSettingsMapping, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.userSettingsMapping = userSettingsMapping;
      [self prepareDeleteButton];
      [self.tableView reloadData];
    });
  }];
}

- (void)prepareDeleteButton {
  if ([self.userSettingsMapping.DeleteRequested boolValue]) {
    [self.deleteProfileButton setTitle:@"Отменить удаление профиля" forState:UIControlStateNormal];
    self.timeLabel.text = [NSString stringWithFormat:@"Удаление профиля. Осталось дней: %ld", (long)[self.userSettingsMapping.DeleteAfter integerValue]];
  } else {
    [self.deleteProfileButton setTitle:@"Удалить профиль" forState:UIControlStateNormal];
    self.timeLabel.text = nil;
  }
}

- (void)loadUserLanguagesFromServer:(BOOL)success {
  if (success) {
    if (self.isCurrentVC) {
      if (self.detailSettingsAccountRow == LanguageDetailRow) {
        [[ServerManager sharedManager] userLanguageListWithCompletion:^(NSArray *languages, NSString *errorMessage) {
          self.addedLanguages = languages;
          [self.tableView reloadData];
        }];
      }
    }
  }
}

- (void)checkCurrentVC:(BOOL)current {
  if (self.detailSettingsAccountRow == LanguageDetailRow) {
    self.isCurrentVC = current;
  }
}

- (void)setupItemsArray {
  switch (self.detailSettingsAccountRow) {
    case ConfidenceDetailRow: {
      self.itemsArray = @[[[DetailSettingsModel alloc] initWithTitle:@"Публичный поиск"
                                                     withDescription:@"Благодаря публичному поиску ваш профиль можно будет найти через поисковые системы интернета"
                                                             andIsOn:[self.userSettingsMapping.VisibleToSearchEngines boolValue]
                                                             andType:VisibleToSearchEngines],
                          [[DetailSettingsModel alloc] initWithTitle:@"Делиться моим профилем"
                                                     withDescription:@"Позволить другим делиться моим профилем"
                                                             andIsOn:[self.userSettingsMapping.AllowToShareProfile boolValue]
                                                             andType:AllowToShareProfile]];
    } break;
      
    case NotificationDetailRow: {
      self.itemsArray = @[[[DetailSettingsModel alloc] initWithTitle:@"Выключить все"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll
                                                             andType:OffAll],
                          [[DetailSettingsModel alloc] initWithTitle:@"Сообщения"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO : [self.userSettingsMapping.NotifyOnChat boolValue]
                                                             andType:NotifyOnChat],
                          [[DetailSettingsModel alloc] initWithTitle:@"Лайки"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO :[self.userSettingsMapping.NotifyOnLike boolValue] andType:NotifyOnLike],
                          [[DetailSettingsModel alloc] initWithTitle:@"Супер лайки"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO :[self.userSettingsMapping.NotifyOnSuperLike boolValue] andType:NotifyOnSuperLike],
                          [[DetailSettingsModel alloc] initWithTitle:@"Добавили в \"Избранные\""
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO :[self.userSettingsMapping.NotifyOnFollower boolValue] andType:NotifyOnFollower],
                          [[DetailSettingsModel alloc] initWithTitle:@"Новости (Подписка на Email)"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO :[self.userSettingsMapping.Subscribed boolValue] andType:Subscribed],
                          [[DetailSettingsModel alloc] initWithTitle:@"Подарки"
                                                     withDescription:nil
                                                             andIsOn:self.isOffAll ? NO :[self.userSettingsMapping.NotifyOnGift boolValue] andType:NotifyOnGift]];
    } break;
      
    case VerificationDetailRow: {
      self.itemsArray = @[[[DetailSettingsModel alloc] initWithTitle:@"Скрыть верификации"
                                                     withDescription:@"Включите, чтобы скрыть данные о подтверждениях в вашем профиле"
                                                             andIsOn:[self.userSettingsMapping.HideLinkedAccounts boolValue]
                                                             andType:HideLinkedAccounts]];
    } break;
      
    case DeleteProfileDetailRow: {
      self.itemsArray = @[[[DetailSettingsModel alloc] initWithTitle:@"Скрыть профиль"
                                                     withDescription:@"Скрыть профиль, как будто вы удалили его, но вернуться можно в любой момент"
                                                             andIsOn:[self.userSettingsMapping.Hidden boolValue]
                                                             andType:Hidden]];
    } break;
      
    default:
      break;
  }
}

- (BOOL)checkIsOnAllNotifications {
  if ([self.userSettingsMapping.NotifyOnChat boolValue] &&
      [self.userSettingsMapping.NotifyOnLike boolValue] &&
      [self.userSettingsMapping.NotifyOnSuperLike boolValue] &&
      [self.userSettingsMapping.NotifyOnFollower boolValue] &&
      [self.userSettingsMapping.Subscribed boolValue] &&
      [self.userSettingsMapping.NotifyOnGift boolValue]) {
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.detailSettingsAccountRow == ConfidenceDetailRow ||
      self.detailSettingsAccountRow == NotificationDetailRow) {
    return self.itemsArray.count;
  } else if (self.detailSettingsAccountRow == VerificationDetailRow) {
    return kSocialRow + self.itemsArray.count;
  } else if (self.detailSettingsAccountRow == DeleteProfileDetailRow) {
    return kClearRow + self.itemsArray.count;
  } else if (self.detailSettingsAccountRow == LanguageDetailRow) {
    return self.addedLanguages.count > 0 ? kLocationRow + self.addedLanguages.count + 1 : kLocationRow + 2;
  } else {
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self heightForCellByIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self heightForCellByIndexPath:indexPath];
}

- (CGFloat)heightForCellByIndexPath:(NSIndexPath *)indexPath {
  if (self.detailSettingsAccountRow == VerificationDetailRow) {
    if (indexPath.row != 0) {
      return 0;
    } else {
      return UITableViewAutomaticDimension;
    }
  } else if (self.detailSettingsAccountRow == NotificationDetailRow) {
    if (indexPath.row == 0) {
      return 0;
    } else {
      return UITableViewAutomaticDimension;
    }
  } else {
    return UITableViewAutomaticDimension;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  DetailSettingsTableViewCell *detailSettingsTableViewCell = nil;
  
  switch (self.detailSettingsAccountRow) {
    case ConfidenceDetailRow: {
      detailSettingsTableViewCell = [self prepareDetailSettingsTableViewCellByIndexPath:indexPath andIndentifier:kDetailSettingsMoreCellIdentifier];
      return detailSettingsTableViewCell;
    } break;
      
    case  NotificationDetailRow: {
      detailSettingsTableViewCell = [self prepareDetailSettingsTableViewCellByIndexPath:indexPath andIndentifier:kDetailSettingsCellIdentifier];
      return detailSettingsTableViewCell;
    } break;
      
    case VerificationDetailRow: {
      if (indexPath.row == kSocialRow - 1) {
        detailSettingsTableViewCell = [tableView dequeueReusableCellWithIdentifier:kDetailSettingsSocialCellIdentifier];
      } else {
        detailSettingsTableViewCell = [self prepareDetailSettingsTableViewCellByIndexPath:indexPath andIndentifier:kDetailSettingsMoreCellIdentifier];
      }
      
      return detailSettingsTableViewCell;
    } break;
      
    case DeleteProfileDetailRow: {
      
      if (indexPath.row == kClearRow - 1) {
        detailSettingsTableViewCell = [self prepareDetailSettingsTableViewCellByIndexPath:indexPath andIndentifier:kDetailSettingsMoreCellIdentifier];
      } else {
        detailSettingsTableViewCell = [tableView dequeueReusableCellWithIdentifier:kDetailSettingsClearCellIdentifier];
      }
      
      return detailSettingsTableViewCell;
    } break;
      
    case LanguageDetailRow: {
      if (self.addedLanguages.count == 0) {
        if (indexPath.row == 0) {
          return [self prepareDetailSettingsLanguageCell];
        } else if (indexPath.row == 1) {
          ProfileFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleLanguageCellIdentifier];
          return cell;
        } else {
          return [self addProfileFormTableViewCell];
        }
      } else {
        if (indexPath.row == 0) {
          return [self prepareDetailSettingsLanguageCell];
        } else {
          if (self.addedLanguages.count == 0) {
            return [self addProfileFormTableViewCell];
          } else {
            if (self.addedLanguages.count == indexPath.row - 1) {
              return [self addProfileFormTableViewCell];
            } else {
              ProfileFormTableViewCell *profileFormCell = [tableView dequeueReusableCellWithIdentifier:kProfileFormCellIdentifier];
              profileFormCell.delegate = self;
              LanguageMapping *mapping = [self.addedLanguages objectAtIndex:indexPath.row - 1];
              [self setupProfileFormObjectByMapping:mapping andCell:profileFormCell];
              [profileFormCell prepareTitleLabelWithMapping:mapping];
              if (indexPath.row - 1 == 0) {
                [profileFormCell hiddenDescriptionTextLabel:NO];
              } else {
                [profileFormCell hiddenDescriptionTextLabel:YES];
              }
              return profileFormCell;
            }
          }
        }
      }
    } break;
      
    default:
      return [UITableViewCell new];
      break;
  }
}

- (ProfileFormTableViewCell *)addProfileFormTableViewCell {
  ProfileFormTableViewCell *profileFormCell = [self.tableView dequeueReusableCellWithIdentifier:kAddProfileFormCellIdentifier];
  return profileFormCell;
}

- (void)setupProfileFormObjectByMapping:(LanguageMapping *)mapping andCell:(UITableViewCell *)cell {
  [(ProfileFormTableViewCell *)cell setObject:mapping];
}

- (DetailSettingsTableViewCell *)prepareDetailSettingsTableViewCellByIndexPath:(NSIndexPath *)indexPath andIndentifier:(NSString *)identifier {
  DetailSettingsTableViewCell *detailSettingsTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
  detailSettingsTableViewCell.delegate = self;
  
  DetailSettingsModel *model = nil;
  if (self.detailSettingsAccountRow == VerificationDetailRow) {
    model = [self.itemsArray objectAtIndex:indexPath.row - 1];
  } else {
    model = [self.itemsArray objectAtIndex:indexPath.row];
  }
  
  detailSettingsTableViewCell.model = model;
  if (self.detailSettingsAccountRow == NotificationDetailRow) {
    [detailSettingsTableViewCell prepareDetailSettingsByModel:model];
  } else {
    [detailSettingsTableViewCell prepareDetailSettingsMoreByModel:model];
  }
  
  return detailSettingsTableViewCell;
}

- (DetailSettingsTableViewCell *)prepareDetailSettingsLanguageCell {
  DetailSettingsTableViewCell *detailSettingsTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:kDetailSettingsLocationCellIdentifier];
  detailSettingsTableViewCell.delegate = self;
  detailSettingsTableViewCell.userSettingsMapping = self.userSettingsMapping;
  [detailSettingsTableViewCell prepareLanguageCellByMapping:self.userSettingsMapping];
  return detailSettingsTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (self.detailSettingsAccountRow) {
    case LanguageDetailRow:
      if (indexPath.row > 1) {
        [self presentLanguagesVC:NO];
      }
      break;
      
    default:
      break;
  }
}

- (void)changeSwitchByModel:(DetailSettingsModel *)model {
  NSString *key = [self keyForParamsByModel:model];
  if (key != nil) {
    NSDictionary * params = @{key : model.isOnDetailSettings ? @(1) : @(0),
                              @"Token" : [Helpers getAccessToken]
                              };
    [[ServerManager sharedManager] setUserSettingsWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      
    }];
  }
}

- (void)changeOriginalSwitchByModel:(DetailSettingsModel *)model {
  NSDictionary *params = nil;
  if (model.type == OffAll) {
    self.isOffAll = model.isOnDetailSettings;
    params = [self paramsForUpdateSettingsByModel:model];
  } else {
    self.isOffAll = NO;
    NSString *key = [self keyForParamsByModel:model];
    if (key != nil) {
      params = @{key : model.isOnDetailSettings ? @(1) : @(0),
                 @"Token" : [Helpers getAccessToken]
                 };
    }
  }
  
  [self updateUserSettingsWithParams:params];
}

- (void)updateUserSettingsWithParams:(NSDictionary *)params {
  [[ServerManager sharedManager] setUserSettingsWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    [[ServerManager sharedManager] getUserSettingsWithCompletion:^(UserSettingsMapping *userSettingsMapping, NSString *errorMessage) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.userSettingsMapping = userSettingsMapping;
        if (self.detailSettingsAccountRow == DeleteProfileDetailRow && [self.userSettingsMapping.Hidden boolValue]) {
          [UIAlertHelper alert:@"Чтобы сделать свой профиль снова видимым, перейдите в “Настройки” и отключите эту функцию" title:@"Профиль скрыт"];
        }
        
        [self setupItemsArray];
        [self.tableView reloadData];
      });
    }];
  }];
}

- (NSDictionary *)paramsForUpdateSettingsByModel:(DetailSettingsModel *)detailSettingsModel {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  for (DetailSettingsModel *model in self.itemsArray) {
    NSString *key = [self keyForParamsByModel:model];
    if (key != nil) {
      model.isOnDetailSettings = detailSettingsModel.isOnDetailSettings ? NO : YES;
      [mutDict setObject:model.isOnDetailSettings ? @(1) : @(0) forKey:key];
    }
  }
  
  return mutDict;
}

- (void)presentLanguagesVC {
  [self presentLanguagesVC:YES];
}

- (void)presentLanguagesVC:(BOOL)isChange {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Languages" andStoryboardId:LANGUAGES_STORYBOARD_ID];
  LanguagesViewController *languagesVC = (LanguagesViewController *)[navVC topViewController];
  languagesVC.delegate = self;
  languagesVC.userSettingsMapping = self.userSettingsMapping;
  languagesVC.addedLanguages = [NSMutableArray arrayWithArray:self.addedLanguages];
  languagesVC.isChange = isChange;
  [self.navigationController pushViewController:languagesVC animated:YES];
}

- (NSString *)keyForParamsByModel:(DetailSettingsModel *)model {
  switch (model.type) {
    case VisibleToSearchEngines: return @"VisibleToSearchEngines"; break;
    case AllowToShareProfile: return @"AllowToShareProfile"; break;
    case NotifyOnChat: return @"NotifyOnChat"; break;
    case NotifyOnLike: return @"NotifyOnLike"; break;
    case NotifyOnSuperLike: return @"NotifyOnSuperLike"; break;
    case NotifyOnFollower: return @"NotifyOnFollower"; break;
    case Subscribed: return @"Subscribed"; break;
    case NotifyOnGift: return @"NotifyOnGift"; break;
    case HideLinkedAccounts: return @"HideLinkedAccounts"; break;
    case Hidden: return @"Hidden"; break;
    default: return nil; break;
  }
}

- (void)setupLanguageByMapping:(LanguageMapping *)mapping {
  if (mapping) {
    [[ServerManager sharedManager] addUserLanguageWithParams:@{@"Token" : [Helpers getAccessToken], @"LanguageId" : mapping.IdLanguage} withCompletion:^(BOOL success, NSString *errorMessage) {
      [self loadUserLanguagesFromServer:success];
    }];
  }
}

- (void)deleteLanguageByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  if (indexPath.row != 0) {
    LanguageMapping *mapping = [self.addedLanguages objectAtIndex:indexPath.row - 1];
    [self deleteLanguageByMapping:mapping];
  }
}

- (void)deleteLanguageByMapping:(LanguageMapping *)mapping {
  if (mapping) {
    [[ServerManager sharedManager] deleteUserLanguageWithParams:@{@"Token" : [Helpers getAccessToken], @"LanguageId" : mapping.IdLanguage} withCompletion:^(BOOL success, NSString *errorMessage) {
      if (success) {
        [self loadUserLanguagesFromServer:success];
      } else {
        [UIAlertHelper alert:nil title:errorMessage];
      }
    }];
  }
}

- (void)changeLanguageByMapping:(LanguageMapping *)mapping {
  if (mapping) {
    NSDictionary *dict = @{@"Token" : [Helpers getAccessToken],
                           @"LanguageId" : mapping.IdLanguage
                           };
    
    [self updateUserSettingsWithParams:dict];
  }
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteProfileDidTap:(UIButton *)sender {
  if ([self.userSettingsMapping.DeleteRequested boolValue]) {
    [[ServerManager sharedManager] unDeleteUserWithCompletion:^(BOOL success, NSString *errorMessage) {
      if (success) {
        [self loadData];
      }
    }];
  } else {
    [UIAlertHelper showCustomAlertWithTitle:@"3 дня бесплатного Ya Max!" withMessage:@"Ya Max на 3 дня, если привяжите карту" withCancelButtonTitle:@"Закрыть" withOkButtonTitle:@"Удалить профиль" withOkCompletion:^(UIButton *sender) {
      [[ServerManager sharedManager] deleteUserWithCompletion:^(BOOL success, NSString *errorMessage) {
        if (success) {
          [self loadData];
        }
      }];
    } withCancelCompletion:^(UIButton *sender) {
      
    } withYaMaxCompletion:^(UIButton *sender) {
      [self presentServicesScreen];
    }];
  }
}

- (void)closeMotivationTranslatorPopupView {
  [Helpers dismissCustomView:self.motivationTranslatorPopupView];
}

- (void)activateTranslatorMotivationTranslatorPopupView {
  [Helpers dismissCustomView:self.motivationTranslatorPopupView];
  [self presentServicesScreen];
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

