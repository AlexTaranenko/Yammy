//
//  NewPasswordViewController.m
//  Yammy
//
//  Created by Alex on 12/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "HaveAccountViewController.h"

@interface NewPasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnToHomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showHidePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *showHideConfirmPasswordButton;

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.descriptionLabel.text = [NSString stringWithFormat:@"В пароле можно использовать латинские буквы,\nцифры и символы .!#@#$%%^&*()_-"];
  self.returnToHomeLabel.attributedText = [self prepareReturnLabel];
  
  self.continueButton.layer.cornerRadius = 5.0f;
  self.continueButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)prepareReturnLabel {
  NSString *text = @"Вернуться к входу";
  NSRange range = [text rangeOfString:@"Вернуться к входу"];
  NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:text];
  
  [mutString addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                             NSForegroundColorAttributeName : RGB(51, 51, 51)
                             } range:range];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToReturnHome:)];
  tapGesture.numberOfTapsRequired = 1;
  self.returnToHomeLabel.userInteractionEnabled = YES;
  [self.returnToHomeLabel addGestureRecognizer:tapGesture];
  
  return mutString;
}

- (void)tapToReturnHome:(UITapGestureRecognizer *)recognizer {
  UIViewController *vc = nil;
  for (UIViewController *vcFromArray in self.navigationController.viewControllers) {
    if ([vcFromArray isKindOfClass:[HaveAccountViewController class]]) {
      vc = vcFromArray;
      break;
    }
  }
  
  if (vc) {
    [self.navigationController popToViewController:vc animated:YES];
  } else {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
}

- (IBAction)passwordEditingChanged:(UITextField *)sender {
  self.loginModel.password = sender.text;
}

- (IBAction)confirmPasswordEditingChanged:(UITextField *)sender {
  self.loginModel.confirmPassword = sender.text;
}

- (IBAction)passwordDidTap:(UIButton *)sender {
  self.showHidePasswordButton.selected = !sender.selected;
  self.passwordTextField.secureTextEntry = !self.showHidePasswordButton.selected;
}

- (IBAction)confirmPasswordDidTap:(UIButton *)sender {
  self.showHideConfirmPasswordButton.selected = !sender.selected;
  self.confirmPasswordTextField.secureTextEntry = !self.showHideConfirmPasswordButton.selected;
}

- (IBAction)continueDidTap:(UIButton *)sender {
  if ([self checkPassword]) {
    NSMutableDictionary *mutDict = [NSMutableDictionary new];
    if (self.loginModel.phoneNumber.length > 0) {
      [mutDict setObject:self.loginModel.phoneNumber forKey:@"Phone"];
    } else if (self.loginModel.email.length > 0) {
      [mutDict setObject:self.loginModel.email forKey:@"Email"];
    }
    
    if (self.loginModel.verificationCode.length > 0) {
      [mutDict setObject:self.loginModel.verificationCode forKey:@"Code"];
    }
    
    [mutDict setObject:self.loginModel.password forKey:@"NewPassword"];
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] changePasswordWithParams:mutDict withCompletion:^(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel) {
      [Helpers hideSpinner];
      if (registerMapping.message != nil) {
        [UIAlertHelper alert:registerMapping.message title:registerMapping.localized];
      } else if (responseStatusModel != nil) {
        [UIAlertHelper alert:responseStatusModel.localized title:responseStatusModel.errorMessage];
      } else {
        [self autoLogin];
      }
    }];
  }
}

- (IBAction)backDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkPassword {
  if (self.loginModel.password.length > 0 && self.loginModel.confirmPassword.length > 0) {
    if ([self.loginModel.password isEqualToString:self.loginModel.confirmPassword]) {
      return YES;
    } else {
      [WToast showWithText:@"Пароли не совпадают"];
      return NO;
    }
  } else {
    [WToast showWithText:@"Поля не должны быть пустыми"];
    return NO;
  }
}

- (void)autoLogin {
  [Helpers showSpinner];
  [[ServerManager sharedManager] loginUserWithParams:[self paramsForLogin] withCompletion:^(RegisterMapping *registerMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (registerMapping) {
      if (registerMapping.code != nil) {
        [UIAlertHelper alert:registerMapping.message title:registerMapping.localized];
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
  
  if (self.loginModel.phoneNumber != nil) {
    [mutDict setObject:self.loginModel.phoneNumber forKey:@"UserName"];
  } else if (self.loginModel.email != nil) {
    [mutDict setObject:self.loginModel.email forKey:@"UserName"];
  }
  
  return mutDict;
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

