//
//  CustomAlertView.m
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "CustomAlertView.h"

typedef void(^OkOneButtonBlock)(UIButton *sender);
typedef void(^OkTwoButtonBlock)(UIButton *sender);
typedef void(^CancelTwoButtonBlock)(UIButton *sender);
typedef void(^YaMaxButtonBlock)(UIButton *sender);

@interface CustomAlertView()

@property (weak, nonatomic) IBOutlet UILabel *titleOneButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageOneButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *okOneButton;

@property (weak, nonatomic) IBOutlet UILabel *titleTwoButtonLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTwoButtonLabel;
@property (weak, nonatomic) IBOutlet UIButton *okTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelTwoButton;

@property (nonatomic) OkOneButtonBlock okOneButtonBlock;
@property (nonatomic) OkTwoButtonBlock okTwoButtonBlock;
@property (nonatomic) CancelTwoButtonBlock cancelTwoButtonBlock;
@property (nonatomic) YaMaxButtonBlock yaMaxButtonBlock;

@end

@implementation CustomAlertView

#pragma mark - Public

+ (CustomAlertView *)createCustomAlertOneButtonView {
  CustomAlertView *customAlertView = (CustomAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomAlertOneButtonView" owner:self options:nil] firstObject];
  customAlertView.frame = [UIScreen mainScreen].bounds;
  return customAlertView;
}

+ (CustomAlertView *)createCustomAlertTwoButtonView {
  CustomAlertView *customAlertView = (CustomAlertView *)[[[NSBundle mainBundle] loadNibNamed:@"CustomAlertTwoButtonView" owner:self options:nil] firstObject];
  customAlertView.frame = [UIScreen mainScreen].bounds;
  return customAlertView;
}

- (void)hideCustomAlertView {
  [Helpers dismissCustomView:self];
}

#pragma mark - One Button View

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message {
  
  [self prepareOneButtonViewWithTitle:title withMessage:message withOkButtonTitle:@"Ок"];
}

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                  withCompletion:(void(^)(UIButton *sender))completion {
  
  [self prepareOneButtonViewWithTitle:title withMessage:message withOkButtonTitle:@"Ок"];
  if (completion != nil) {
    self.okOneButtonBlock = completion;
  }
}

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
               withTitleOkButton:(NSString *)titleOkButton
                  withCompletion:(void(^)(UIButton *sender))completion {
  
  [self prepareOneButtonViewWithTitle:title withMessage:message withOkButtonTitle:titleOkButton];
  if (completion != nil) {
    self.okOneButtonBlock = completion;
  }
}

- (void)prepareOneButtonViewWithTitle:(NSString *)title
                          withMessage:(NSString *)message
                    withOkButtonTitle:(NSString *)okButtonTitle {
  
  self.titleOneButtonLabel.text = title;
  self.messageOneButtonLabel.text = message;
  [self.okOneButton setTitle:okButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Two Button View

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion {
  
  [self prepareTwoButtonWithTitle:title withMessage:message withCancelButtonTitle:@"Отмена" withOkButtonTitle:@"Ок"];
  if (okCompletion != nil) {
    self.okTwoButtonBlock = okCompletion;
  }
}

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion {
  
  [self prepareTwoButtonWithTitle:title withMessage:message withCancelButtonTitle:@"Отмена" withOkButtonTitle:@"Ок"];
  
  if (okCompletion != nil) {
    self.okTwoButtonBlock = okCompletion;
  }
  
  if (cancelCompletion != nil) {
    self.cancelTwoButtonBlock = cancelCompletion;
  }
}

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
           withCancelButtonTitle:(NSString *)cancelButtonTitle
               withOkButtonTitle:(NSString *)okButtonTitle
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion
             withYaMaxCompletion:(void(^)(UIButton *sender))yaMaxCompletion {
  
  [self prepareTwoButtonWithTitle:title withMessage:message withCancelButtonTitle:cancelButtonTitle withOkButtonTitle:okButtonTitle];
  
  if (okCompletion != nil) {
    self.okTwoButtonBlock = okCompletion;
  }
  
  if (cancelCompletion != nil) {
    self.cancelTwoButtonBlock = cancelCompletion;
  }
  
  if (yaMaxCompletion != nil) {
    self.yaMaxButtonBlock = yaMaxCompletion;
  }
}

- (void)prepareTwoButtonWithTitle:(NSString *)title
                      withMessage:(NSString *)message
            withCancelButtonTitle:(NSString *)cancelButtonTitle
                withOkButtonTitle:(NSString *)okButtonTitle {
  
  self.titleTwoButtonLabel.text = title;
  self.messageTwoButtonLabel.text = message;
  [self.cancelTwoButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
  [self.okTwoButton setTitle:okButtonTitle forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)okOneButtonDidTap:(UIButton *)sender {
  if (self.okOneButtonBlock != nil) {
    self.okOneButtonBlock(sender);
  }
  
  [self hideCustomAlertView];
}

- (IBAction)okTwoButtonDidTap:(UIButton *)sender {
  if (self.okTwoButtonBlock != nil) {
    self.okTwoButtonBlock(sender);
  }
  
  [self hideCustomAlertView];
}

- (IBAction)cancelTwoButtonDidTap:(UIButton *)sender {
  if (self.cancelTwoButtonBlock != nil) {
    self.cancelTwoButtonBlock(sender);
  }
  
  [self hideCustomAlertView];
}

- (IBAction)receiveYaMaxDidTap:(CustomButton *)sender {
  
  if (self.yaMaxButtonBlock != nil) {
    self.yaMaxButtonBlock(sender);
  }
  
  [self hideCustomAlertView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
