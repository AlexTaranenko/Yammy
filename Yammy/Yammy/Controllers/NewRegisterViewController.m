//
//  NewRegisterViewController.m
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "NewRegisterViewController.h"
#import "RegisterModel.h"
#import "NewRegisterNameTableViewCell.h"
#import "NewRegisterCodeTableViewCell.h"
#import "NewRegisterPasswordTableViewCell.h"
#import "HaveAccountViewController.h"

@interface NewRegisterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIView *oneButtonContainerView;
@property (weak, nonatomic) IBOutlet UIView *twoButtonContainerView;

@property (weak, nonatomic) IBOutlet UILabel *notMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) RegisterModel *registerModel;
@property (assign, nonatomic) BOOL isShowDescriptionCode;

@end

@implementation NewRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if ([self.loginModel.type isEqualToString:@"Native"]) {
    self.registerModel = [[RegisterModel alloc] init];
  } else {
    self.registerModel = [[RegisterModel alloc] initWithLoginModel:self.loginModel];
  }
  
  if (self.isFromMyAccount || self.isFromLogin) {
    [self resetRegisterModelByIsRecovery:YES];
  } else {
    [self resetRegisterModelByIsRecovery:NO];
  }
  
  [self prepareNewRegisterInterface];
  [self prepareContainers];
  
  [self prepareBackBarButtonItem];
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshCodeDidTap)];
  [self.notMailLabel addGestureRecognizer:gesture];
  self.notMailLabel.userInteractionEnabled = YES;
  [self setupNotMailLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  if (self.isFromLogin) {
    [self.navigationController setNavigationBarHidden:YES];
  }
}

- (void)setupNotMailLabel {
  self.notMailLabel.text = @"Отправить код еще раз";
}

- (void)prepareNewRegisterInterface {
  self.navigationItem.title = self.registerModel.isRecoveryPassword ? @"Восстановление пароля" : @"Регистрация";
  
  if (self.registerModel.nameUser != nil && self.registerModel.code != nil) {
    if (self.registerModel.isRecoveryPassword) {
      self.titleLabel.text = @"Придумайте новый пароль";
    } else {
      self.titleLabel.text = @"Придумайте пароль";
    }
    [self.progressView setProgress:0.75 animated:YES];
    
  } else if (self.registerModel.nameUser != nil && self.registerModel.code == nil) {
    self.titleLabel.text = [NSString stringWithFormat:@"Проверьте ваш(у) %@", self.registerModel.nameUser];
    
    [self.progressView setProgress:0.5 animated:YES];
  } else {
    if (self.registerModel.isRecoveryPassword) {
      self.titleLabel.text = @"Данные для восстановления";
    } else {
      self.titleLabel.text = @"Введите данные для регистрации";
    }
    
    [self.progressView setProgress:0.25 animated:YES];
  }
  
  UIView *v = self.tableView.tableHeaderView;
  CGRect fr = v.frame;
  
  if (self.registerModel.nameUser != nil && self.registerModel.code == nil) {
    self.subTitleLabel.text = [NSString stringWithFormat:@"Мы отправили Вам сообщение на %@. Пожалуйста, проверьте почту и введите указаный 4-х значный код.", self.registerModel.nameUser];
    CGFloat labelHeight = [self getLabelHeight:self.subTitleLabel];
    fr.size.height = 129 + labelHeight + 10;
  } else {
    fr.size.height = 139;
  }
  
  v.frame = fr;
  [self.tableView updateConstraintsIfNeeded];
}

- (CGFloat)getLabelHeight:(UILabel*)label {
  CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
  CGSize size;
  
  NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
  CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:label.font}
                                                context:context].size;
  
  size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
  
  return size.height;
}

- (void)resetRegisterModelByIsRecovery:(BOOL)isRecovery {
  self.registerModel.isRecoveryPassword = isRecovery;
  self.registerModel.nameUser = nil;
  self.registerModel.code = nil;
  self.registerModel.password = nil;
  self.registerModel.confirmPassword = nil;
}

- (void)prepareContainers {
  
  self.oneButtonContainerView.hidden = NO;
  self.twoButtonContainerView.hidden = YES;
  
  if (self.registerModel.nameUser != nil && self.registerModel.code != nil) {
    if (self.isShowDescriptionCode) {
      self.oneButtonContainerView.hidden = YES;
      self.twoButtonContainerView.hidden = NO;
    }
  } else if (self.registerModel.nameUser != nil && self.registerModel.code == nil) {
    self.oneButtonContainerView.hidden = YES;
    self.twoButtonContainerView.hidden = NO;
  }
  
  UIView *v = self.tableView.tableFooterView;
  CGRect fr = v.frame;
  fr.size.height = 104;
  
  if (self.twoButtonContainerView.hidden == NO) {
    if (self.isShowDescriptionCode) {
      self.descriptionLabel.text = @"Для начала, проверьте папку Спам в Вашей почте. Убедитесь, что вы ввели почту верно.";
      CGFloat labelHeight = [self getLabelHeight:self.descriptionLabel];
      fr.size.height = 104 + labelHeight + 30;
    } else {
      self.descriptionLabel.text = @"";
    }
  }
  
  v.frame = fr;
  [self.tableView updateConstraintsIfNeeded];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.registerModel.nameUser != nil ? 0 : 1;
  } else if (section == 1) {
    if (self.registerModel.nameUser != nil && self.registerModel.code == nil) {
      return 1;
    } else {
      return 0;
    }
  } else {
    if (self.registerModel.nameUser != nil && self.registerModel.code != nil) {
      return 1;
    } else {
      return 0;
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    NewRegisterNameTableViewCell *newRegisterName = [tableView dequeueReusableCellWithIdentifier:kNewRegisterNameIdentifier];
    newRegisterName.registerModel = self.registerModel;
    newRegisterName.nameTextField.text = self.registerModel.nameUser;
    return newRegisterName;
  } else if (indexPath.section == 1) {
    NewRegisterCodeTableViewCell *newRegisterCode = [tableView dequeueReusableCellWithIdentifier:kNewRegisterCodeIdentifier];
    newRegisterCode.registerModel = self.registerModel;
    return newRegisterCode;
  } else {
    NewRegisterPasswordTableViewCell *newRegisterPassword = [tableView dequeueReusableCellWithIdentifier:kNewRegisterPasswordIdentifier];
    newRegisterPassword.registerModel = self.registerModel;
    return newRegisterPassword;
  }
}

- (void)checkAvailableProfile {
  [[ServerManager sharedManager] checkAvailableProfileWithParams:@{@"UserName" : self.registerModel.nameUser} withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 503) {
      [UIAlertHelper alert:responseStatusModel.errorMessage title:responseStatusModel.localized cancelButton:@"Ок" successButton:@"Восстановить" successCompletion:^(UIAlertAction *action) {
        [self resetRegisterModelByIsRecovery:YES];
        [self prepareNewRegisterInterface];
        [self prepareContainers];
        [self.tableView reloadData];
      }];
    } else if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 525) {
      if (self.registerModel.isRefresh) {
        [WToast showWithText:responseStatusModel.errorMessage duration:5.0];
        self.registerModel.isRefresh = NO;
      } else {
        [self prepareNewRegisterInterface];
        [self reloadTableView];
      }
    } else if (responseStatusModel.localized != nil) {
      [UIAlertHelper alert:responseStatusModel.errorMessage title:responseStatusModel.localized];
    } else {
      [self prepareNewRegisterInterface];
      [self reloadTableView];
    }
  }];
}

- (void)reloadTableView {
  self.registerModel.code = nil;
  [self prepareContainers];
  [self.tableView reloadData];
}

- (void)registerNewUser {
  NSDictionary *params = @{@"Type" : self.registerModel.typeUser,
                           @"UserName" : self.registerModel.nameUser,
                           @"Code" : self.registerModel.code,
                           @"Password" : self.registerModel.password};
  
  NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:params];
  if (self.registerModel.socialToken != nil) {
    [mutDict setObject:self.registerModel.socialToken forKey:@"SocialToken"];
  }
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] registerUserWithParams:mutDict withFileData:nil withCompletion:^(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel) {
    [Helpers hideSpinner];
    
    if (registerMapping.token != nil) {
      [Helpers saveAccessToken:registerMapping.token];
      
      [self.progressView setProgress:1.0 animated:YES];
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DELEGATE setupTabBarControllerWithSelectIndex:MyProfileTabBarIndex];
      });
    } else {
      [UIAlertHelper alert:registerMapping.message title:registerMapping.localized];
    }
  }];
}

- (void)confirmProfile {
  [[ServerManager sharedManager] confirmProfileWithParams:@{@"UserName" : self.registerModel.nameUser, @"Code" : self.registerModel.code} withCompletion:^(ResponseStatusModel *responseStatusModel, BOOL status, NSString *errorMessage) {
    if (responseStatusModel.code != nil) {
      [UIAlertHelper alert:responseStatusModel.errorMessage title:responseStatusModel.localized];
    } else {
      [self prepareNewRegisterInterface];
      [self prepareContainers];
      [self.tableView reloadData];
    }
  }];
}

- (void)recoveryProfile {
  [[ServerManager sharedManager] recoverProfileWithParams:@{@"UserName" : self.registerModel.nameUser} withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 525) {
      if (self.registerModel.isRefresh) {
        [WToast showWithText:responseStatusModel.errorMessage duration:5.0];
        self.registerModel.isRefresh = NO;
      } else {
        [self prepareNewRegisterInterface];
        [self reloadTableView];
      }
    } else if (responseStatusModel.localized != nil) {
      [UIAlertHelper alert:responseStatusModel.errorMessage title:responseStatusModel.localized];
    } else {
      [self prepareNewRegisterInterface];
      [self reloadTableView];
    }
  }];
}

- (void)recoverProfileAllowed {
  [[ServerManager sharedManager] recoverAllowedProfileWithParams:@{@"UserName" : self.registerModel.nameUser, @"Code" : self.registerModel.code} withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    if (responseStatusModel.code != nil) {
      [UIAlertHelper alert:responseStatusModel.errorMessage title:responseStatusModel.localized];
    } else {
      [self prepareNewRegisterInterface];
      [self prepareContainers];
      [self.tableView reloadData];
    }
  }];
}

- (void)changePassword {
  NSDictionary *params = @{@"UserName" : self.registerModel.nameUser,
                           @"Code" : self.registerModel.code,
                           @"NewPassword" : self.registerModel.password};
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] changePasswordWithParams:params withCompletion:^(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel) {
    [Helpers hideSpinner];
    
    [self.progressView setProgress:1.0 animated:YES];
    if (self.isFromMyAccount) {
      [self.navigationController popViewControllerAnimated:YES];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WToast showWithText:@"Ваш пароль изменен" duration:5.0];
      });
    } else if (self.isFromLogin) {
      [WToast showWithText:@"Ваш пароль изменен" duration:5.0];
      
      [Helpers showSpinner];
      [[ServerManager sharedManager] loginUserWithParams:[self paramsForLogin] withCompletion:^(RegisterMapping *registerMapping, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (registerMapping) {
          if (registerMapping.code == nil) {
            [Helpers saveAccessToken:registerMapping.token];
            [[ServerManager sharedManager] getProfileById:@(0) withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
              if (profileMapping) {
                [ServerManager sharedManager].myProfileMapping = profileMapping;
              }
            }];
            
            [DELEGATE setupTabBarControllerWithSelectIndex:HomeTabBarIndex];
          }
        }
      }];
    } else {
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
  }];
}

- (NSDictionary *)paramsForLogin {
  NSMutableDictionary *mutDict = [NSMutableDictionary new];
  [mutDict setObject:self.registerModel.typeUser forKey:@"Type"];
  [mutDict setObject:self.registerModel.password != nil ? self.registerModel.password : @"" forKey:@"Password"];
  
  if (self.registerModel.email != nil) {
    [mutDict setObject:self.registerModel.email forKey:@"UserName"];
  }
  
  return mutDict;
}

- (IBAction)firstContinueDidTap:(UIButton *)sender {
  if (self.registerModel.nameUser != nil && self.registerModel.code == nil) {
    if (self.registerModel.isRecoveryPassword == NO) {
      [self checkAvailableProfile];
    } else {
      [self recoveryProfile];
    }
  } else if (self.registerModel.nameUser != nil && self.registerModel.code != nil) {
    if (self.registerModel.password != nil && self.registerModel.confirmPassword != nil) {
      if ([self.registerModel.password isEqualToString:self.registerModel.confirmPassword] == NO) {
        [WToast showWithText:@"Пароли не совпадают."];
      } else {
        if (self.registerModel.isRecoveryPassword == NO) {
          [self registerNewUser];
        } else {
          [self changePassword];
        }
      }
    } else {
      if (self.registerModel.password.length == 0) {
        [WToast showWithText:@"Введите свой пароль."];
      } else if (self.registerModel.confirmPassword.length == 0) {
        [WToast showWithText:@"Введите пароль для подтверждения."];
      }
    }
  }
  else {
    [WToast showWithText:@"Введите свой номер телефона или емейл."];
  }
}

- (void)refreshCodeDidTap {
  if (self.registerModel.nameUser != nil) {
    if (self.isShowDescriptionCode) {
      self.registerModel.isRefresh = YES;
      if (self.registerModel.isRecoveryPassword == NO) {
        [self checkAvailableProfile];
      } else {
        [self reloadTableView];
        [self recoveryProfile];
      }
    } else {
      self.isShowDescriptionCode = YES;
      [self prepareContainers];
      [self setupNotMailLabel];
    }
  } else {
    [WToast showWithText:@"Введите свой номер телефона или емейл."];
  }
}

- (IBAction)secondContinueDidTap:(UIButton *)sender {
  if (self.registerModel.nameUser != nil && self.registerModel.code != nil) {
    if (self.registerModel.isRecoveryPassword == NO) {
      [self confirmProfile];
    } else {
      [self recoverProfileAllowed];
    }
  } else {
    [WToast showWithText:@"Введите код."];
  }
}

- (void)backButtonDidTap:(id)sender {
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

