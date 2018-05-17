//
//  RecoveryPasswordViewController.m
//  Yammy
//
//  Created by Alex on 12/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "RecoveryPasswordViewController.h"
#import "CodeRegisterViewController.h"

@interface RecoveryPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@end

@implementation RecoveryPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.emailTextField.text = self.registerModel != nil ? self.registerModel.email : self.loginModel.email;
  self.phoneNumberTextField.text = self.registerModel != nil ? self.registerModel.phoneNumber : self.loginModel.phoneNumber;
  
  self.continueButton.layer.cornerRadius = 5.0f;
  self.continueButton.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)emailEditingChanged:(UITextField *)sender {
  if (self.registerModel != nil) {
    self.registerModel.email = sender.text;
  } else {
    self.loginModel.email = sender.text;
  }
}

- (IBAction)phoneNumberEditingChanged:(UITextField *)sender {
  if (self.registerModel != nil) {
    self.registerModel.phoneNumber = sender.text;
  } else {
    self.loginModel.phoneNumber = sender.text;
  }
}

- (IBAction)continueDidTap:(UIButton *)sender {
  if ([self paramsForRecover] != nil) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] recoverProfileWithParams:[self paramsForRecover] withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (responseStatusModel.code == nil) {
        UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"CodeRegister" andStoryboardId:CODE_REGISTER_STORYBOARD_ID];
        CodeRegisterViewController *codeRegisterVC = (CodeRegisterViewController *)[navVC topViewController];
        codeRegisterVC.loginModel = self.loginModel;
        [self.navigationController pushViewController:codeRegisterVC animated:YES];
      } else {
        [WToast showWithText:@"Не правильно ввели номер телефона или Email"];
      }
    }];
  } else {
    [WToast showWithText:@"Введите номер телефона или емейл."];
  }
}

- (NSDictionary *)paramsForRecover {
  NSString *phone = self.registerModel != nil ? self.registerModel.phoneNumber : self.loginModel.phoneNumber;
  NSString *email = self.registerModel != nil ? self.registerModel.email : self.loginModel.email;
  
  if (phone.length > 0) {
    return @{@"Phone" : phone};
  } else if (email.length > 0) {
    return @{@"Email" : email};
  } else {
    return nil;
  }
}

- (IBAction)backDidTap:(UIButton *)sender {
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

