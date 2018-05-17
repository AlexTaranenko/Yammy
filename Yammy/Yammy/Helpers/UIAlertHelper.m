#import "UIAlertHelper.h"
#import "CustomAlertView.h"
#import "CustomAlertTextFieldView.h"

@implementation UIAlertHelper

+ (void)alert:(NSString *)text title:(NSString *)title {
  UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
  
  [self prepareBackgroundColorByController:alert];
  [self prepareTitle:title andMessage:text withAlert:alert];
  
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:nil];
  [alert addAction:action];
  
  [action setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alert:(NSString *)text title:(NSString *)title successCompletion:(SuccessAlertCompletion)completion {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
  
  [self prepareBackgroundColorByController:alert];
  [self prepareTitle:title andMessage:text withAlert:alert];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completion(action);
  }];
  
  [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  
  [alert addAction:cancelAction];
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alert:(NSString *)text title:(NSString *)title cancelButton:(NSString *)cancel successButton:(NSString *)theSuccessButton successCompletion:(SuccessButtonAlertCompletion)completion {
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
  
  [self prepareBackgroundColorByController:alert];
  [self prepareTitle:title andMessage:text withAlert:alert];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:nil];
  UIAlertAction *successAction = [UIAlertAction actionWithTitle:theSuccessButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completion(action);
  }];
  
  [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  [successAction setValue:RGB(249, 0, 64) forKey:@"titleTextColor"];
  
  [alert addAction:cancelAction];
  [alert addAction:successAction];
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alert:(NSString *)text title:(NSString *)title cancelButton:(NSString *)cancel successButton:(NSString *)theSuccessButton withCompletion:(SuccessAndCancelButtonAlertCompletion)completion {
  
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
  
  [self prepareBackgroundColorByController:alert];
  [self prepareTitle:title andMessage:text withAlert:alert];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completion(nil, action);
  }];
  
  UIAlertAction *successAction = [UIAlertAction actionWithTitle:theSuccessButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completion(action, nil);
  }];
  
  [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  [successAction setValue:RGB(249, 0, 64) forKey:@"titleTextColor"];
  
  [alert addAction:cancelAction];
  [alert addAction:successAction];
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)alertTextField:(NSString *)text title:(NSString *)title placehodelr:(NSString *)placeholder withOkButton:(NSString *)okButton withCancelButton:(NSString *)cancelButton withCompletion:(TextFieldAlertCompletion)completion {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
  
  [self prepareBackgroundColorByController:alert];
  [self prepareTitle:title andMessage:@"" withAlert:alert];
  
  [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.text = text;
    textField.font = [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder ?: @""  attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0]}];
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    UITextField *txtField = (UITextField *)[alert textFields].firstObject;
    completion(nil, action, txtField);
  }];
  
  UIAlertAction *successAction = [UIAlertAction actionWithTitle:okButton style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    UITextField *txtField = (UITextField *)[alert textFields].firstObject;
    completion(action, nil, txtField);
  }];
  
  [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  [successAction setValue:RGB(249, 0, 64) forKey:@"titleTextColor"];
  
  [alert addAction:cancelAction];
  [alert addAction:successAction];
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
  
}

+ (void)prepareBackgroundColorByController:(UIAlertController *)alertController {
  UIView *firstSubview = alertController.view.subviews.firstObject;
  UIView *alertContentView = firstSubview.subviews.firstObject;
  for (UIView *subSubView in alertContentView.subviews) { //This is main catch
    subSubView.backgroundColor = [UIColor whiteColor]; //Here you change background
  }
}

+ (void)prepareTitle:(NSString *)title andMessage:(NSString *)text withAlert:(UIAlertController *)alertController {
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title ?: @"" attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:16.0]}];
  [alertController setValue:attrString forKey:@"attributedTitle"];
  
  NSAttributedString *attrMessageString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", text ?: @""] attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:14.0]}];
  [alertController setValue:attrMessageString forKey:@"attributedMessage"];
}

// Custom Alert

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertOneButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message];
  [[self class] showAnimationForCustomAlert:customAlertView];
}

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                  withCompletion:(void(^)(UIButton *sender))completion {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertOneButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message withCompletion:completion];
  [[self class] showAnimationForCustomAlert:customAlertView];
}

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
               withTitleOkButton:(NSString *)titleOkButton
                  withCompletion:(void(^)(UIButton *sender))completion {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertOneButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message withTitleOkButton:titleOkButton withCompletion:completion];
  [[self class] showAnimationForCustomAlert:customAlertView];
}

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertTwoButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message withOkCompletion:okCompletion];
  [[self class] showAnimationForCustomAlert:customAlertView];
}

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertTwoButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message withOkCompletion:okCompletion withCancelCompletion:cancelCompletion];
  [[self class] showAnimationForCustomAlert:customAlertView];
}

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
           withCancelButtonTitle:(NSString *)cancelButtonTitle
               withOkButtonTitle:(NSString *)okButtonTitle
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion
             withYaMaxCompletion:(void(^)(UIButton *sender))yaMaxCompletion {
  
  CustomAlertView *customAlertView = [CustomAlertView createCustomAlertTwoButtonView];
  [customAlertView showCustomAlertWithTitle:title withMessage:message withCancelButtonTitle:cancelButtonTitle withOkButtonTitle:okButtonTitle withOkCompletion:okCompletion withCancelCompletion:cancelCompletion withYaMaxCompletion:yaMaxCompletion];
  [[self class] showAnimationForCustomAlert:customAlertView];
}


+ (void)showAnimationForCustomAlert:(UIView *)customAlertView {
  [UIView transitionWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^ {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:customAlertView]; }
                  completion:nil];
}

// Custom Alert with text field

+ (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                          withButtonTitle:(NSString *)buttonTitle
                           withCompletion:(void(^)(UIButton *sender, UITextField *testField))completion {
  
  CustomAlertTextFieldView *customAlertTextFieldView = [CustomAlertTextFieldView createCustomAlertTextFieldOneButtonView];
  [customAlertTextFieldView showCustomAlertTextFieldWithTitle:title withMessage:message withPlaceholder:placeholder withButtonTitle:buttonTitle withCompletion:completion];
  [[self class] showAnimationForCustomAlert:customAlertTextFieldView];
}

+ (void)showCustomAlertTextFieldWithTitle:(NSString *)title
                              withMessage:(NSString *)message
                          withPlaceholder:(NSString *)placeholder
                        withOkButtonTitle:(NSString *)okButtonTitle
                    withCancelButtonTitle:(NSString *)cancelButtonTitle
                         withOkCompletion:(void(^)(UIButton *sender, UITextField *testField))okCompletion
                     withCancelCompletion:(void(^)(UIButton *sender, UITextField *testField))cancelCompletion {
  
  CustomAlertTextFieldView *customAlertTextFieldView = [CustomAlertTextFieldView createCustomAlertTextFieldTwoButtonView];
  [customAlertTextFieldView showCustomAlertTextFieldWithTitle:title withMessage:message withPlaceholder:placeholder withOkButtonTitle:okButtonTitle withCancelButtonTitle:cancelButtonTitle withOkCompletion:okCompletion withCancelCompletion:cancelCompletion];
  [[self class] showAnimationForCustomAlert:customAlertTextFieldView];
}


@end

