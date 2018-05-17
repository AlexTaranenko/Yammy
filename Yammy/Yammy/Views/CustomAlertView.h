//
//  CustomAlertView.h
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView

+ (CustomAlertView *)createCustomAlertOneButtonView;

+ (CustomAlertView *)createCustomAlertTwoButtonView;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                  withCompletion:(void(^)(UIButton *sender))completion;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
               withTitleOkButton:(NSString *)titleOkButton
                  withCompletion:(void(^)(UIButton *sender))completion;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion;

- (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
           withCancelButtonTitle:(NSString *)cancelButtonTitle
               withOkButtonTitle:(NSString *)okButtonTitle
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion
             withYaMaxCompletion:(void(^)(UIButton *sender))yaMaxCompletion;

@end
