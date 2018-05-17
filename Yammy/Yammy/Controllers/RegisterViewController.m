//
//  RegisterViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "RegisterViewController.h"
#import "NameRegisterTableViewCell.h"
#import "SexRegisterTableViewCell.h"
#import "BirthdayRegisterTableViewCell.h"
#import "InterestMeRegisterTableViewCell.h"
#import "OrientationRegisterTableViewCell.h"
#import "CalendarRegisterViewController.h"
#import "FinishRegisterViewController.h"
#import "RegisterModel.h"
#import "LocationManager.h"
#import <GooglePlaces/GooglePlaces.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>

static NSInteger kRegisterSectionsCount = 4;

@interface RegisterViewController ()<UITableViewDelegate, UITableViewDataSource, CalendarRegisterViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) NSArray *orientationsArray;
@property (strong, nonatomic) NSArray *gendersArray;
@property (strong, nonatomic) RegisterModel *registerModel;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if ([self.loginModel.type isEqualToString:@"Native"]) {
    self.registerModel = [[RegisterModel alloc] init];
  } else {
    self.registerModel = [[RegisterModel alloc] initWithLoginModel:self.loginModel];
  }
  
  [self preparePhotoImageView];
  
  if ([LocationManager sharedManager].location != nil) {
    self.locationView.hidden = YES;
  }
  
  [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:kRealReachabilityChangedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self loadDataFromServer];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
}

- (void)loadDataFromServer {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    dispatch_group_t group = nil;
    if (self.orientationsArray.count == 0 && self.gendersArray.count == 0) {
      group = dispatch_group_create();
      
      [Helpers showSpinner];
      
      dispatch_group_enter(group);
      [[ServerManager sharedManager] getDictionaryOfListByPath:GENDER withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
        if (dictionaryListArray) {
          self.gendersArray = dictionaryListArray;
        }
        dispatch_group_leave(group);
      }];
      
      dispatch_group_enter(group);
      [[ServerManager sharedManager] getDictionaryOfListByPath:GENDER_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
        if (dictionaryListArray) {
          self.orientationsArray = dictionaryListArray;
        }
        dispatch_group_leave(group);
      }];
      
      dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [Helpers hideSpinner];
        [self.tableView reloadData];
      });
    }
  }
}

- (void)preparePhotoImageView {
  if (self.registerModel.imageFileData != nil) {
    self.photoImageView.image = [UIImage imageWithData:self.registerModel.imageFileData];
  }
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return section == NameRegisterSection ? 8.f : 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return section == NameRegisterSection ? 8.f : 20.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kRegisterSectionsCount;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *sectionView = [UIView new];
  if (section == NameRegisterSection) {
    [sectionView setBackgroundColor:[UIColor whiteColor]];
  } else {
    [sectionView setBackgroundColor:RGB(235, 235, 235)];
  }
  return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == NameRegisterSection) {
    return 1;
  } else if (section == SexRegisterSection) {
    return 1;
  } else if (section == BirthDayRegisterSection) {
    return 1;
  } else {
    return 1 + self.orientationsArray.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == NameRegisterSection) {
    NameRegisterTableViewCell *nameRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"nameRegisterTableCell"];
    nameRegisterTableCell.registerModel = self.registerModel;
    [nameRegisterTableCell prepareNameRegisterByModel:self.registerModel];
    return nameRegisterTableCell;
  } else if (indexPath.section == SexRegisterSection) {
    SexRegisterTableViewCell *sexRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"sexRegisterTableCell"];
    [sexRegisterTableCell prepareButtonsByArray:self.gendersArray];
    sexRegisterTableCell.registerModel = self.registerModel;
    [sexRegisterTableCell prepareSexRegisterByModel:self.registerModel];
    return sexRegisterTableCell;
  } else if (indexPath.section == BirthDayRegisterSection) {
    BirthdayRegisterTableViewCell *birthdayRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"birthdayRegisterTableCell"];
    [birthdayRegisterTableCell prepareBirthdayRegisterByModel:self.registerModel];
    return birthdayRegisterTableCell;
  } else {
    if (indexPath.row == 0) {
      InterestMeRegisterTableViewCell *interestMeRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"interestMeRegisterTableCell"];
      interestMeRegisterTableCell.registerModel = self.registerModel;
      [interestMeRegisterTableCell prepareShowControl];
      interestMeRegisterTableCell.separatorInset = UIEdgeInsetsMake(0, tableView.frame.size.width, 0, 0);
      return interestMeRegisterTableCell;
    } else {
      OrientationRegisterTableViewCell *orientationRegisterTableCell = [tableView dequeueReusableCellWithIdentifier:@"orientationRegisterTableCell"];
      DictionaryMapping *mapping = [self.orientationsArray objectAtIndex:indexPath.row - 1];
      [orientationRegisterTableCell prepareNameByGenderMapping:mapping];
      NSArray *filterdArray = [self.registerModel.orientationUser filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
      if (filterdArray.count > 0) {
        [orientationRegisterTableCell selectSquareCheckBox:YES];
      } else {
        [orientationRegisterTableCell selectSquareCheckBox:NO];
      }
      return orientationRegisterTableCell;
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == InterestPersonRegisterSection) {
    DictionaryMapping *mapping = [self.orientationsArray objectAtIndex:indexPath.row - 1];
    NSArray *filterdArray = [self.registerModel.orientationUser filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
    if (filterdArray.count > 0) {
      DictionaryMapping *mappingFromArray = (DictionaryMapping *)[filterdArray firstObject];
      NSInteger index = [self.registerModel.orientationUser indexOfObject:mappingFromArray];
      [self.registerModel.orientationUser removeObjectAtIndex:index];
    } else {
      [self.registerModel.orientationUser addObject:mapping];
    }
    [self.tableView reloadData];
    
  } else if (indexPath.section == BirthDayRegisterSection) {
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"CalendarRegister" andStoryboardId:CALENDAR_REGISTER_STORYBOARD_ID];
    CalendarRegisterViewController *calendarRegisterVC = (CalendarRegisterViewController *)[navVC topViewController];
    calendarRegisterVC.delegate = self;
    calendarRegisterVC.registerModel = self.registerModel;
    [self presentViewController:navVC animated:YES completion:nil];
  }
}

#pragma mark - Delegate

- (void)prepareBirthdayTableCell {
  if (self.registerModel.birthdayUser) {
    [self.tableView reloadData];
  }
}

#pragma mark - Photo

- (void)presentPhotoAlertController {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Сделать фото" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self presentCameraPhoto];
  }];
  
  UIAlertAction *gallery = [UIAlertAction actionWithTitle:@"Загрузить из галлереи" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self presentPhotoGallery];
  }];
  
  UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil];
  
  [alert addAction:camera];
  [alert addAction:gallery];
  [alert addAction:cancel];
  
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentCameraPhoto {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypeCamera];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нет камеры" title:@"Отсутствует камера"];
  }
}

- (void)presentPhotoGallery {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нету галлереи" title:@"Отсутствует галлерея"];
  }
}

- (void)presentPickerViewBySourceType:(UIImagePickerControllerSourceType)sourceType {
  [Helpers showSpinner];
  UIImagePickerController *picker = [UIImagePickerController new];
  picker.delegate = self;
  picker.allowsEditing = YES;
  picker.sourceType = sourceType;
  if (sourceType == UIImagePickerControllerSourceTypeCamera) {
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
  }
  [self presentViewController:picker animated:YES completion:^{
    [Helpers hideSpinner];
  }];
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  [Helpers showSpinner];
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (image) {
    self.registerModel.imageFileData = UIImageJPEGRepresentation(image, 0.8);
    [self preparePhotoImageView];
  }
  
  [picker dismissViewControllerAnimated:YES completion:^{
    [Helpers hideSpinner];
  }];
}

#pragma mark - Location Autocomplete

- (IBAction)changeLocationDidTap:(id)sender {
  GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
  acController.delegate = self;
  [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
  [self dismissViewControllerAnimated:YES completion:nil];
  [self.locationButton setTitle:place.name forState:UIControlStateNormal];
  [LocationManager sharedManager].location = [[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
  // TODO: handle the error.
  NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Actions

- (IBAction)photoDidTap:(UIButton *)sender {
  [self presentPhotoAlertController];
}

- (IBAction)backDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(UIButton *)sender {
  if ([self.registerModel.typeUser isEqualToString:@"Native"]) {
    [self checkIsEmptyFieldWithCompletion:^(BOOL success, NSString *message) {
      if (success) {
        UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"FinishRegister" andStoryboardId:FINISH_REGISTER_STORYBOARD_ID];
        FinishRegisterViewController *finishRegisterVC = (FinishRegisterViewController *)[navVC topViewController];
        finishRegisterVC.registerModel = self.registerModel;
        [self.navigationController pushViewController:finishRegisterVC animated:YES];
      } else {
        [WToast showWithText:message];
      }
    }];
  } else {
    [Helpers showSpinner];
    [[ServerManager sharedManager] registerUserWithParams:[self paramsForRegister] withFileData:self.registerModel.imageFileData withCompletion:^(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel) {
      [Helpers hideSpinner];
      if (registerMapping) {
        if (registerMapping.code != nil) {
          if ([registerMapping.code integerValue] == kStatusCodeInvalidRequestProfilesRegisterEmailAlreadyExists ||
              [registerMapping.code integerValue] == kStatusCodeInvalidRequestProfilesRegisterPhoneAlreadyExists) {
            [UIAlertHelper alert:registerMapping.message title:registerMapping.localized cancelButton:@"Ок" successButton:@"Восстановить" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction) {
              if (successAction) {
                // To Do
              }
            }];
          } else {
            [UIAlertHelper alert:registerMapping.message title:registerMapping.localized];
          }
        } else {
          [Helpers saveAccessToken:registerMapping.token];
          
          [[ServerManager sharedManager] getProfileById:@(0) withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
            if (profileMapping) {
              [ServerManager sharedManager].myProfileMapping = profileMapping;
            }
          }];
          
          [DELEGATE setupTabBarControllerWithSelectIndex:MyProfileTabBarIndex];
        }
      }
    }];
  }
}

- (NSDictionary *)paramsForRegister {
  NSMutableDictionary *mutDict = [NSMutableDictionary new];
  
  [mutDict setObject:self.registerModel.typeUser != nil ? self.registerModel.typeUser : @"Native" forKey:@"Type"];
  
  [mutDict setObject:self.registerModel.nameUser != nil ? self.registerModel.nameUser : @"" forKey:@"Name"];
  
  [mutDict setObject:self.registerModel.sexUser != nil ? self.registerModel.sexUser : @"" forKey:@"SexId"];
  
  [mutDict setObject:self.registerModel.isInterestedGendersHidden != nil ? self.registerModel.isInterestedGendersHidden : @(0) forKey:@"IsInterestedGendersHidden"];
  
  [mutDict setObject:self.registerModel.birthdayUser != nil ? @([self.registerModel.birthdayUser timeIntervalSince1970]) : @"" forKey:@"BirthDate"];
  
  NSMutableString *mutString = [NSMutableString new];
  for (DictionaryMapping *mapping in self.registerModel.orientationUser) {
    NSInteger index = [self.registerModel.orientationUser indexOfObject:mapping];
    [mutString appendFormat:@"%@", mapping.IdDictionary];
    if (index + 1 != self.registerModel.orientationUser.count) {
      [mutString appendString:@","];
    }
  }
  
  [mutDict setObject:mutString forKey:@"InterestedGenderIds"];
  
  if (self.registerModel.email != nil) {
    [mutDict setObject:self.registerModel.email != nil ? self.registerModel.email : @"" forKey:@"Email"];
  } else if (self.registerModel.phoneNumber != nil) {
    [mutDict setObject:self.registerModel.phoneNumber != nil ? self.registerModel.phoneNumber : @"" forKey:@"Phone"];
  }
  
  [mutDict setObject:self.registerModel.socialToken != nil ? self.registerModel.socialToken : @"" forKey:@"SocialToken"];
  
  [mutDict setObject:self.registerModel.password != nil ? self.registerModel.password : @"" forKey:@"Password"];
  
  [mutDict setObject:@(1) forKey:@"LocationId"];
  
  return mutDict;
}

- (void)checkIsEmptyFieldWithCompletion:(void(^)(BOOL success, NSString *message))completion {
  if (self.registerModel.nameUser == nil || self.registerModel.nameUser.length == 0) {
    completion(NO, @"Введите свое имя");
    return;
  }
  
  if (self.registerModel.sexUser == nil) {
    completion(NO, @"Выберите свой пол");
    return;
  }
  
  if (self.registerModel.birthdayUser == nil) {
    completion(NO, @"Введите дату рождения");
    return;
  }
  
  if (self.registerModel.orientationUser == nil) {
    completion(NO, @"Выберите интересы");
    return;
  }
  
  if ([LocationManager sharedManager].location == nil && self.registerModel.locationId == nil) {
    completion(NO, @"Выберите локацию");
    return;
  }
  
  completion(YES, nil);
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

