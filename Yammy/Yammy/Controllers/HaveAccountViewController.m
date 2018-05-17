//
//  HaveAccountViewController.m
//  Yammy
//
//  Created by Alex on 01.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HaveAccountViewController.h"
#import "LoginModel.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "NewRegisterViewController.h"

@interface HaveAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (strong, nonatomic) LoginModel *loginModel;

@end

@implementation HaveAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Логин";
  self.loginModel = [[LoginModel alloc] init];
  
  [self prepareBackBarButtonItem];
  
  self.passwordTextField.inputAccessoryView = [Helpers createToolbarWithTarget:self WithHandler:@selector(passwordDoneDidTap:)];
  self.emailTextField.inputAccessoryView = [Helpers createToolbarWithTarget:self WithHandler:@selector(emailDoneDidTap:)];
  
  self.enterButton.layer.cornerRadius = 5.0f;
  self.enterButton.clipsToBounds = YES;
  self.bottomLabel.attributedText = [self prepareBottomLabel];
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
  
  if (self.isFromRegister == NO) {
    [self.navigationController setNavigationBarHidden:YES];
  }
}

- (NSAttributedString *)prepareBottomLabel {
  NSAttributedString *mutString = [[NSAttributedString alloc] initWithString:@"Забыли пароль?" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                                                                                                            NSForegroundColorAttributeName : RGB(205, 205, 205)}];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRecovery:)];
  tapGesture.numberOfTapsRequired = 1;
  self.bottomLabel.userInteractionEnabled = YES;
  [self.bottomLabel addGestureRecognizer:tapGesture];
  
  return mutString;
}

- (void)passwordDoneDidTap:(id)sender {
  [self.view endEditing:YES];
}

- (void)emailDoneDidTap:(id)sender {
  [self.view endEditing:YES];
}

- (void)tapToRecovery:(UITapGestureRecognizer *)recognizer {
  [self presentRecoveryPasswordController];
}

- (IBAction)emailEditingChanged:(UITextField *)sender {
  self.loginModel.email = sender.text;
}
- (IBAction)passwordEditingChanged:(UITextField *)sender {
  self.loginModel.password = sender.text;
}

- (void)backButtonDidTap:(id)sender {
  if (self.isFromRegister) {
    [self.navigationController popToRootViewControllerAnimated:YES];
  } else {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (IBAction)enterDidTap:(UIButton *)sender {
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
  UIViewController *vc = nil;
  for (UIViewController *vcFromArray in self.navigationController.viewControllers) {
    if ([vcFromArray isKindOfClass:[NewRegisterViewController class]]) {
      [(NewRegisterViewController *)vcFromArray setIsFromLogin:YES];
      vc = vcFromArray;
      break;
    }
  }
  
  if (vc) {
    [self.navigationController popToViewController:vc animated:YES];
  } else {
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"NewRegister" andStoryboardId:NEW_REGISTER_STORYBOARD_ID];
    NewRegisterViewController *regicterVC = (NewRegisterViewController *)[navVC topViewController];
    regicterVC.isFromLogin = YES;
    [self.navigationController pushViewController:regicterVC animated:YES];
  }
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

