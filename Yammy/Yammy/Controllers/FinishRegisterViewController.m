//
//  FinishRegisterViewController.m
//  Yammy
//
//  Created by Alex on 8/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "FinishRegisterViewController.h"
#import "HaveAccountViewController.h"
#import "PasswordViewController.h"

@interface FinishRegisterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end

@implementation FinishRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.titleLabel.text = @"Чтобы продолжить регистрацию, укажите телефон или Email:";
  
  self.phoneTextField.inputAccessoryView = [Helpers createToolbarWithTarget:self WithHandler:@selector(phoneDoneDidTap:)];
  self.emailTextField.inputAccessoryView = [Helpers createToolbarWithTarget:self WithHandler:@selector(emailDoneDidTap:)];
  
  self.enterButton.layer.cornerRadius = 5.0f;
  self.enterButton.clipsToBounds = YES;
  
  self.emailTextField.text = self.registerModel.email;
  self.phoneTextField.text = self.registerModel.phoneNumber;
  self.bottomLabel.attributedText = [self prepareBottomLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)prepareBottomLabel {
  NSString *text = @"У меня уже есть аккаунт войти.";
  NSRange range = [text rangeOfString:@"войти."];
  NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:text];
  
  [mutString addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
                             NSForegroundColorAttributeName : RGB(205, 205, 205)
                             } range:range];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRegister:)];
  tapGesture.numberOfTapsRequired = 1;
  self.bottomLabel.userInteractionEnabled = YES;
  [self.bottomLabel addGestureRecognizer:tapGesture];
  
  return mutString;
}

- (void)phoneDoneDidTap:(id)sender {
  [self.view endEditing:YES];
}

- (void)emailDoneDidTap:(id)sender {
  [self.view endEditing:YES];
}

- (void)tapToRegister:(UITapGestureRecognizer *)recognizer {
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
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"HaveAccount" andStoryboardId:HAVE_ACCOUNT_STORYBOARD_ID];
    HaveAccountViewController *haveAccountVC = (HaveAccountViewController *)[navVC topViewController];
    [self.navigationController pushViewController:haveAccountVC animated:YES];
  }
}

- (IBAction)phoneEditingChanged:(UITextField *)sender {
  self.registerModel.phoneNumber = sender.text;
}

- (IBAction)emailEditingChanged:(UITextField *)sender {
  self.registerModel.email = sender.text;
}

- (IBAction)enterDidTap:(UIButton *)sender {
  [self checkEmailOrPhoneNumberWithCompletion:^(BOOL status, NSString *errorMessage) {
    if (status) {
      NSDictionary *params;
      if (self.registerModel.phoneNumber != nil) {
        params = @{@"Phone" : self.registerModel.phoneNumber};
      } else {
        params = @{@"Email" : self.registerModel.email};
      }
      
      [[ServerManager sharedManager] checkAvailableProfileWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
        if (responseStatusModel) {
          UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Password" andStoryboardId:PASSWORD_STORYBOARD_ID];
          PasswordViewController *passwordVC = (PasswordViewController *)[navVC topViewController];
          passwordVC.registerModel = self.registerModel;
          [self.navigationController pushViewController:passwordVC animated:YES];
        } else {
          [WToast showWithText:@"Номер телефона или почтовый ящик уже существуют."];
        }
      }];
    } else {
      [WToast showWithText:errorMessage];
    }
  }];
}

- (void)checkEmailOrPhoneNumberWithCompletion:(void (^)(BOOL status, NSString *errorMessage))completion {
  if (self.registerModel.phoneNumber == nil && self.registerModel.email == nil) {
    completion(NO, @"Введите свой номер телефона или емейл.");
  } else {
    completion(YES, nil);
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

