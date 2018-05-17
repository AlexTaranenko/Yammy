//
//  CustomAlertTextFieldView.h
//  Yammy
//
//  Created by Alex on 1/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OkButtonBlock)(UIButton *sender, UITextField *testField);
typedef void(^CancelButtonBlock)(UIButton *sender, UITextField *testField);

@interface CustomAlertTextFieldView : UIView

+ (CustomAlertTextFieldView *)createCustomAlertTextFieldOneButtonView;

+ (CustomAlertTextFieldView *)createCustomAlertTextFieldTwoButtonView;

- (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                          withButtonTitle:(NSString *)buttonTitle
                           withCompletion:(OkButtonBlock)completion;

- (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                        withOkButtonTitle:(NSString *)okButtonTitle
                    withCancelButtonTitle:(NSString *)cancelButtonTitle
                         withOkCompletion:(OkButtonBlock)okCompletion
                     withCancelCompletion:(CancelButtonBlock)cancelCompletion;

@end

