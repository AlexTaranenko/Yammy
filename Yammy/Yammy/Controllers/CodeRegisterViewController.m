//
//  CodeRegisterViewController.m
//  Yammy
//
//  Created by Alex on 8/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CodeRegisterViewController.h"
#import "NewPasswordViewController.h"

@interface CodeRegisterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *containerTextFieldArray;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourTextField;
@property (weak, nonatomic) IBOutlet UILabel *smsMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CodeRegisterViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  NSString *stringNumber = nil;
  if (self.registerModel != nil || self.loginModel != nil) {
    if (self.registerModel.phoneNumber.length > 0 || self.loginModel.phoneNumber.length > 0) {
      stringNumber = self.registerModel != nil ? self.registerModel.phoneNumber : self.loginModel.phoneNumber;
    } else if (self.registerModel.email.length > 0 || self.loginModel.email.length > 0) {
      stringNumber = self.registerModel != nil ? self.registerModel.email : self.loginModel.email;
    }
  }
  
  if (self.registerModel != nil || self.loginModel != nil) {
    if (self.registerModel.phoneNumber.length > 0 || self.loginModel.phoneNumber.length > 0) {
      self.titleLabel.text = @"Введите код из SMS";
      self.smsMessageLabel.text = [NSString stringWithFormat:@"Мы отправили SMS с кодом\nна номер %@", stringNumber ?: @""];
    } else {
      self.titleLabel.text = @"Введите код полученный по Email";
      self.smsMessageLabel.text = @"На указанный вами Email отправлено письмо с кодом восстановления доступа.";
    }
  }
  
  self.oneTextField.text = zeroWidthSpace;
  self.twoTextField.text = zeroWidthSpace;
  self.threeTextField.text = zeroWidthSpace;
  self.fourTextField.text = zeroWidthSpace;
  
  [self prepareContainerTextFields];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.oneTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)prepareContainerTextFields {
  for (UIView *container in self.containerTextFieldArray) {
    container.layer.borderColor = RGB(204, 204, 204).CGColor;
    container.layer.borderWidth = 1.f;
    container.layer.cornerRadius = 3.f;
    container.clipsToBounds = YES;
  }
}

- (IBAction)textChanged:(UITextField *)sender {
  
  if (sender.tag == 10) {
    if (sender.text.length > 1) {
      self.oneTextField.text = [sender.text substringWithRange:NSMakeRange(1, 1)];
    }
    
    [self showNextTextFieldByCurrentTextField:sender andNextTextField:self.twoTextField];
  } else if (sender.tag == 11) {
    if (sender.text.length > 1) {
      self.twoTextField.text = [sender.text substringWithRange:NSMakeRange(1, 1)];
    }
    
    [self showNextTextFieldByCurrentTextField:sender andNextTextField:self.threeTextField];
  } else if (sender.tag == 12) {
    if (sender.text.length > 1) {
      self.threeTextField.text = [sender.text substringWithRange:NSMakeRange(1, 1)];
    }
    
    [self showNextTextFieldByCurrentTextField:sender andNextTextField:self.fourTextField];
  } else {
    if (sender.text.length > 1) {
      self.fourTextField.text = [sender.text substringWithRange:NSMakeRange(1, 1)];
    }
    
    if (sender.text.length != 0) {
      [sender resignFirstResponder];
    }
  }
}

- (void)showNextTextFieldByCurrentTextField:(UITextField *)sender andNextTextField:(UITextField *)nextTextField {
  if (sender.text.length != 0) {
    [nextTextField becomeFirstResponder];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.view endEditing:YES];
  return YES;
}

- (IBAction)backDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(UIButton *)sender {
  if (self.registerModel != nil) {
    if ([self isWhiteSpace]) {
      if (self.registerModel.email.length > 0) {
        [WToast showWithText:@"Введите код, полученный на ваш E-mail адрес, указанный при регистрации"];
      } else {
        [WToast showWithText:@"Введите код, полученный на ваш номер телефона, указанный при регистрации"];
      }
    } else {
      [Helpers showSpinner];
      [[ServerManager sharedManager] confirmProfileWithParams:@{@"Token" : self.registerMapping.token, @"SmsCode" : [self smsCodeString]} withCompletion:^(ResponseStatusModel *responseStatusModel, BOOL status, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (status) {
          [Helpers saveAccessToken:self.registerMapping.token];
          
          [[ServerManager sharedManager] getProfileById:@(0) withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
            if (profileMapping) {
              [ServerManager sharedManager].myProfileMapping = profileMapping;
            }
          }];
        }
        
        [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
      }];
    }
  }
}

static NSString* zeroWidthSpace = @"\u200B";

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if ([string isEqualToString:@""]) {
    textField.text = zeroWidthSpace;
    
    // goto prev text field
    NSInteger currentTag = textField.tag;
    NSInteger prevTag = currentTag - 1;
    if(prevTag >= 10)
    {
      UITextField *prevTextField = (UITextField *)[self.view viewWithTag:prevTag];
      prevTextField.text= zeroWidthSpace;
      [prevTextField becomeFirstResponder];
    }
    
    return NO;
    
  } else {
    if ([self isWhiteSpace]) {
      if (self.loginModel.email.length > 0) {
        [WToast showWithText:@"Введите код, полученный на ваш E-mail адрес, указанный при регистрации"];
      } else {
        [WToast showWithText:@"Введите код, полученный на ваш номер телефона, указанный при регистрации"];
      }
    } else {
      self.loginModel.verificationCode = [self smsCodeString];
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"NewPassword" andStoryboardId:NEW_PASSWORD_STORYBOARD_ID];
      NewPasswordViewController *newPasswordVC = (NewPasswordViewController *)[navVC topViewController];
      newPasswordVC.loginModel = self.loginModel;
      [self.navigationController pushViewController:newPasswordVC animated:YES];
    }
    
    return YES;
  }
}


- (NSString *)smsCodeString {
  return [NSString stringWithFormat:@"%@%@%@%@", self.oneTextField.text, self.twoTextField.text, self.threeTextField.text, self.fourTextField.text];
}

- (BOOL)isWhiteSpace {
  if ([self smsCodeString].length == 4) {
    NSRange whiteSpaceRange = [[self smsCodeString] rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return YES;
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


