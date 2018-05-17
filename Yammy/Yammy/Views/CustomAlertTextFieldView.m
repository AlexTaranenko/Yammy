//
//  CustomAlertTextFieldView.m
//  Yammy
//
//  Created by Alex on 1/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "CustomAlertTextFieldView.h"

@interface CustomAlertTextFieldView()

@property (weak, nonatomic) IBOutlet UILabel *titleOneButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *okOneButton;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOneButton;
@property (weak, nonatomic) IBOutlet UIButton *okTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelTwoButton;

@property (nonatomic) OkButtonBlock okButtonBlock;
@property (nonatomic) CancelButtonBlock cancelButtonBlock;

@end

@implementation CustomAlertTextFieldView

+ (CustomAlertTextFieldView *)createCustomAlertTextFieldOneButtonView {
  CustomAlertTextFieldView *customAlertTextFieldView = (CustomAlertTextFieldView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomAlertTextFieldOneButtonView" owner:self options:nil] firstObject];
  customAlertTextFieldView.frame = [UIScreen mainScreen].bounds;
  return customAlertTextFieldView;
}

+ (CustomAlertTextFieldView *)createCustomAlertTextFieldTwoButtonView {
  CustomAlertTextFieldView *customAlertTextFieldView = (CustomAlertTextFieldView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomAlertTextFieldTwoButtonView" owner:self options:nil] firstObject];
  customAlertTextFieldView.frame = [UIScreen mainScreen].bounds;
  return customAlertTextFieldView;
}

- (void)hideCustomAlertTextFieldView {
  [Helpers dismissCustomView:self];
}

- (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                          withButtonTitle:(NSString *)buttonTitle
                           withCompletion:(OkButtonBlock)completion {
  
  self.titleOneButtonLabel.text = title;
  self.textFieldOneButton.text = message;
  self.textFieldOneButton.placeholder = placeholder;
  [self.okOneButton setTitle:buttonTitle.length > 0 ? buttonTitle : @"Ок" forState:UIControlStateNormal];
  if (completion != nil) {
    self.okButtonBlock = completion;
  }
}

- (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                        withOkButtonTitle:(NSString *)okButtonTitle
                    withCancelButtonTitle:(NSString *)cancelButtonTitle
                         withOkCompletion:(OkButtonBlock)okCompletion
                     withCancelCompletion:(CancelButtonBlock)cancelCompletion {
  
  self.titleOneButtonLabel.text = title;
  self.textFieldOneButton.text = message;
  self.textFieldOneButton.placeholder = placeholder;
  [self.okTwoButton setTitle:okButtonTitle.length > 0 ? okButtonTitle : @"Ок" forState:UIControlStateNormal];
  [self.cancelTwoButton setTitle:cancelButtonTitle.length > 0 ? cancelButtonTitle : @"Отмена" forState:UIControlStateNormal];
  
  if (okCompletion != nil) {
    self.okButtonBlock = okCompletion;
  }
  
  if (cancelCompletion != nil) {
    self.cancelButtonBlock = cancelCompletion;
  }
}

- (IBAction)okOneButtonDidTap:(UIButton *)sender {
  if (self.okButtonBlock != nil) {
    self.okButtonBlock(sender, self.textFieldOneButton);
  }
  
  [self hideCustomAlertTextFieldView];
}

- (IBAction)okTwoButtonDidTap:(UIButton *)sender {
  if (self.okButtonBlock != nil) {
    self.okButtonBlock(sender, self.textFieldOneButton);
  }
  
  [self hideCustomAlertTextFieldView];
}

- (IBAction)cancelTwoButtonDidTap:(UIButton *)sender {
  if (self.cancelButtonBlock != nil) {
    self.cancelButtonBlock(sender, self.textFieldOneButton);
  }
  
  [self hideCustomAlertTextFieldView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

