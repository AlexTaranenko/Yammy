//
//  PasswordViewController.m
//  Yammy
//
//  Created by Alex on 12/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PasswordViewController.h"
#import "CodeRegisterViewController.h"
#import "RecoveryPasswordViewController.h"
#import "A_ClickableLabel.h"
#import "A_AttributedStringBuilder.h"

static NSString *const kConditionsText = @" Условия";
static NSString *const kServiceText = @"\nобслуживания";
static NSString *const kContactText = @" контактные";
static NSString *const kDataText = @" данные";

static NSString *const kPasswordOneText = @"Забыли";
static NSString *const kPasswordTwoText = @" пароль";

@interface PasswordViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet A_ClickableLabel *linkLabel;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self prepareTitleLabel];
  
  self.enterButton.layer.cornerRadius = 5.0f;
  self.enterButton.clipsToBounds = YES;
  
//  [self prepareLinkTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)prepareTitleLabel {
  if (self.registerModel != nil) {
    self.titleLabel.text = [NSString stringWithFormat:@"Для завершения регистрации,\nпридумайте пароль:"];
  } else {
    self.titleLabel.text = [NSString stringWithFormat:@"Для входа введите пароль,\nуказанный при регистрации:"];
  }
}

- (void)prepareLinkTextView {
  
  aClickableLabelTouchEvent touchEvent = ^(A_ClickableElement *element, A_ClickableLabel *sender, A_ClickedAdditionalInformation *info) {
    
    NSString *selectedWord = info.selectedWord;
    
    if (self.registerModel != nil) {
      if ([selectedWord isEqualToString:kConditionsText] ||
          [selectedWord isEqualToString:kServiceText]) {
        NSLog(@"Terms");
      } else {
        NSLog(@"Contact");
      }
    } else {
      if ([selectedWord isEqualToString:kPasswordOneText] ||
          [selectedWord isEqualToString:kPasswordTwoText] ||
          [selectedWord isEqualToString:@"?"]) {
        [self presentRecoveryPasswordControllerByLoginModel:self.loginModel orRegisterModel:self.registerModel];
      } else if ([selectedWord isEqualToString:kConditionsText] ||
                 [selectedWord isEqualToString:kServiceText]) {
        NSLog(@"Terms");
      } else {
        NSLog(@"Contact");
      }
    }
  };
  
  A_ClickableElement *conditions = [self createElementWithText:@"Условия" withTouch:touchEvent];
  A_ClickableElement *service = [self createElementWithText:@"обслуживания" withTouch:touchEvent];
  A_ClickableElement *contact = [self createElementWithText:@"контактные данные" withTouch:touchEvent];
  
  if (self.registerModel != nil) {
    [self.linkLabel setSentence:@"Продолжая, вы принимаете наши %@\n%@. Мы не разглашаем ваши %@." withBuilder:[A_AttributedStringBuilder createFromAttributes:[self attributeDefaultLabel]] andElements: @[conditions, service, contact]];
  } else {
    A_ClickableElement *password = [A_ClickableElement create:@"Забыли пароль?" withBuilder:[A_AttributedStringBuilder createFromAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:17], NSForegroundColorAttributeName : RGB(51, 51, 51)}] andClick:touchEvent];
    
    [self.linkLabel setSentence:@"%@\nПродолжая, вы принимаете наши %@\n%@. Мы не разглашаем ваши %@." withBuilder:[A_AttributedStringBuilder createFromAttributes:[self attributeDefaultLabel]] andElements: @[password, conditions, service, contact]];
  }
  
}

- (NSDictionary *)attributeDefaultLabel {
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  return @{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14], NSForegroundColorAttributeName : RGB(153, 153, 153)};
}

- (A_ClickableElement *)createElementWithText:(NSString *)text withTouch:(aClickableLabelTouchEvent)touchEvent {
  return [A_ClickableElement create:text withBuilder:[A_AttributedStringBuilder createFromAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:14]}] andClick:touchEvent];
}

#pragma mark - Actions

- (IBAction)enterDidTap:(UIButton *)sender {
  if (self.registerModel != nil) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] registerUserWithParams:[self paramsForRegister] withFileData:self.registerModel.imageFileData withCompletion:^(RegisterMapping *registerMapping, ResponseStatusModel *responseStatusModel) {
      [Helpers hideSpinner];
      if (registerMapping) {
        if ([registerMapping.code integerValue] == 511) {
          [self pushToCodeRegisterByRegisterMapping:registerMapping];
        } else if (registerMapping.code != nil) {
          if ([registerMapping.code integerValue] == kStatusCodeInvalidRequestProfilesRegisterEmailAlreadyExists ||
              [registerMapping.code integerValue] == kStatusCodeInvalidRequestProfilesRegisterPhoneAlreadyExists) {
            [UIAlertHelper alert:registerMapping.message title:registerMapping.localized cancelButton:@"Восстановить" successButton:@"Ок" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction) {
              if (cancelAction) {
                [self presentRecoveryPasswordControllerByLoginModel:self.loginModel orRegisterModel:self.registerModel];
              }
            }];
          } else {
            [UIAlertHelper alert:registerMapping.message title:registerMapping.localized];
          }
        } else {
          [self pushToCodeRegisterByRegisterMapping:registerMapping];
        }
      }
    }];
  } else {
    [Helpers showSpinner];
    [[ServerManager sharedManager] loginUserWithParams:[self paramsForLogin] withCompletion:^(RegisterMapping *registerMapping, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (registerMapping) {
        if (registerMapping.code != nil) {
          [UIAlertHelper alert:registerMapping.message title:registerMapping.localized cancelButton:@"Попробовать снова" successButton:@"Восстановить" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction) {
            if (successAction) {
              [self presentRecoveryPasswordControllerByLoginModel:self.loginModel orRegisterModel:self.registerModel];
            }
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
}

- (void)pushToCodeRegisterByRegisterMapping:(RegisterMapping *)registerMapping {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"CodeRegister" andStoryboardId:CODE_REGISTER_STORYBOARD_ID];
  CodeRegisterViewController *codeRegisterVC = (CodeRegisterViewController *)[navVC topViewController];
  codeRegisterVC.registerModel = self.registerModel;
  codeRegisterVC.registerMapping = registerMapping;
  [self.navigationController pushViewController:codeRegisterVC animated:YES];
}

- (IBAction)passwordEditingChanged:(UITextField *)sender {
  if (self.registerModel != nil) {
    self.registerModel.password = sender.text;
  } else {
    self.loginModel.password = sender.text;
  }
}

- (IBAction)backDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Params

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
  
  //  [mutDict setObject:self.registerModel.locationId != nil ? self.registerModel.locationId : @(1) forKey:@"LocationId"];
  
  return mutDict;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

