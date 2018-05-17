//
//  LoginViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "GeoSearchViewController.h"
#import "HaveAccountViewController.h"
#import "FacebookHalper.h"
#import "TwitterHelper.h"
#import "GooglePlusHelper.h"
#import "GooglePlusUser.h"
#import "VKHelper.h"
#import "OKHelper.h"
#import "LoginModel.h"
#import "NewRegisterViewController.h"

@interface LoginViewController ()<GooglePlusHelperDelegate, VKHelperDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *recoveryLabel;

@property (strong, nonatomic) LoginModel *loginModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.loginModel = [[LoginModel alloc] init];
  
  [[VKHelper sharedVKHelper] setupVKWithDelegate:self];
  
  self.recoveryLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Забыли пароль?" attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToRecovery)];
  tapGesture.numberOfTapsRequired = 1;
  [self.recoveryLabel addGestureRecognizer:tapGesture];
  self.recoveryLabel.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
}

- (IBAction)emailEditingChanged:(UITextField *)sender {
  self.loginModel.email = sender.text;
}

- (IBAction)passwordEditingChanged:(UITextField *)sender {
  self.loginModel.password = sender.text;
}

- (void)pushToRegister {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"NewRegister" andStoryboardId:NEW_REGISTER_STORYBOARD_ID];
  NewRegisterViewController *newRegisterVC = (NewRegisterViewController *)[navVC topViewController];
  newRegisterVC.loginModel = self.loginModel;
  [self.navigationController pushViewController:newRegisterVC animated:YES];
}

- (void)pushToRecovery {
  [self presentRecoveryPasswordController];
}

#pragma mark - Action

- (IBAction)registerDidTap:(UIButton *)sender {
  [self.loginModel resetValues];
  [self pushToRegister];
}

- (IBAction)loginDidTap:(UIButton *)sender {
  [Helpers showSpinner];
  [[ServerManager sharedManager] loginUserWithParams:[self paramsForLogin] withCompletion:^(RegisterMapping *registerMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (registerMapping) {
      if (registerMapping.code != nil) {
        [UIAlertHelper alert:registerMapping.message title:registerMapping.localized cancelButton:@"Попробовать снова" successButton:@"Восстановить" successCompletion:^(UIAlertAction *action) {
          [self presentRecoveryPasswordController];
        }];
      } else {
        [Helpers saveAccessToken:registerMapping.token];
        
        [[ServerManager sharedManager] getProfileById:@(0) withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
          if (profileMapping) {
            [ServerManager sharedManager].myProfileMapping = profileMapping;
          }
        }];
        
        [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
      }
    }
  }];
}

- (NSDictionary *)paramsForLogin {
  NSMutableDictionary *mutDict = [NSMutableDictionary new];
  [mutDict setObject:self.loginModel.type forKey:@"Type"];
  [mutDict setObject:self.loginModel.password != nil ? self.loginModel.password : @"" forKey:@"Password"];
  
  if (self.loginModel.email != nil) {
    [mutDict setObject:self.loginModel.email forKey:@"UserName"];
  }
  
  return mutDict;
}

- (void)presentRecoveryPasswordController {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"NewRegister" andStoryboardId:NEW_REGISTER_STORYBOARD_ID];
  NewRegisterViewController *regicterVC = (NewRegisterViewController *)[navVC topViewController];
  regicterVC.isFromLogin = YES;
  [self.navigationController pushViewController:regicterVC animated:YES];
}

- (IBAction)loginFacebookDidTap:(UIButton *)sender {
  [Helpers showSpinner];
  [[FacebookHalper sharedFacebookHelper] checkIfAlreadyLoggedInonFinished:^(BOOL valid, FacebookUser *user) {
    [Helpers hideSpinner];
    if (!valid) {
      [Helpers showSpinner];
      [[FacebookHalper sharedFacebookHelper] loginToFacebookOnFinished:^(BOOL success, FacebookUser *user) {
        [Helpers hideSpinner];
        if (success) {
          self.loginModel.type = @"Facebook";
          self.loginModel.socialToken = [FacebookHalper accessToken].tokenString;
          [self.loginModel setupValuesByFacebookUser:user];
          [self loginSocialUserWithParams:@{@"Type" : self.loginModel.type, @"SocialToken" : self.loginModel.socialToken}];
        }
      }];
    } else {
      self.loginModel.type = @"Facebook";
      self.loginModel.socialToken = [FacebookHalper accessToken].tokenString;
      [self.loginModel setupValuesByFacebookUser:user];
      [self loginSocialUserWithParams:@{@"Type" : self.loginModel.type, @"SocialToken" : self.loginModel.socialToken}];
    }
  }];
}

- (void)loginSocialUserWithParams:(NSDictionary *)params {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    [Helpers showSpinner];
    [[ServerManager sharedManager] loginUserWithParams:params withCompletion:^(RegisterMapping *registerMapping, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (registerMapping.token == nil) {
        [self pushToRegister];
      } else {
        [Helpers saveAccessToken:registerMapping.token];
        
        [[ServerManager sharedManager] getProfileById:@(0) withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
          if (profileMapping) {
            [ServerManager sharedManager].myProfileMapping = profileMapping;
          }
        }];
        
        [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
      }
    }];
  }
}

- (IBAction)loginTwitterDidTap:(UIButton *)sender {
  [Helpers showSpinner];
  [[TwitterHelper sharedTwitterHelper] checkIfAlreadyLoggedInonFinished:^(BOOL success, TwitterUser *user) {
    [Helpers hideSpinner];
    if (!success) {
      [Helpers showSpinner];
      [[TwitterHelper sharedTwitterHelper] loginToTwitterOnFinished:^(BOOL success, TwitterUser *user) {
        [Helpers hideSpinner];
        if (success) {
          [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
        }
      }];
    } else {
      [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
    }
  }];
}

- (IBAction)googlePlusDidTap:(UIButton *)sender {
  [[GooglePlusHelper sharedGooglePlusHelper] tryLoginWith:self];
}

- (IBAction)vkDidTap:(UIButton *)sender {
  [[VKHelper sharedVKHelper] loginToVK];
}

- (IBAction)okDidTap:(UIButton *)sender {
  [Helpers showSpinner];
  [[OKHelper sharedOKHelper] loginToOKWithCompletion:^(BOOL isSuccess, OKUserModel *okUserModel) {
    [Helpers hideSpinner];
    if (isSuccess) {
      [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
    }
  }];
}

#pragma mark - VK Delegate

- (void)didVKLogin {
  [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
}

- (void)didVKError {
  // To Do
}

#pragma mark - Google Plus Delegate

- (void)didGooglePlusLogin {
  [Helpers hideSpinner];
  [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
  GooglePlusUser *user = [[GooglePlusHelper sharedGooglePlusHelper] loggedUser];
  NSString *fullName = user.user.profile.name;
  NSString *givenName = user.user.profile.givenName;
  NSString *familyName = user.user.profile.familyName;
  NSLog(@"%@ %@ %@", fullName,givenName,familyName);
}

- (void)didGooglePlusLogout {
  // To Do
}

- (void)didGooglePlusDisconnect{
  // To Do
}

- (void)didGooglePlusFailWithError:(NSError *)error {
  NSLog(@"Fail login %@", [error localizedDescription]);
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

