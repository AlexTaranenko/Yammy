#import <UIKit/UIKit.h>

typedef void(^SuccessAlertCompletion)(UIAlertAction *action);
typedef void(^SuccessButtonAlertCompletion)(UIAlertAction *action);
typedef void(^SuccessAndCancelButtonAlertCompletion)(UIAlertAction *successAction, UIAlertAction *cancelAction);
typedef void(^TextFieldAlertCompletion)(UIAlertAction *successAction, UIAlertAction *cancelAction, UITextField *textField);

@interface UIAlertHelper : NSObject

+ (void)alert:(NSString *)text title:(NSString *)title;

+ (void)alert:(NSString *)text title:(NSString *)title successCompletion:(SuccessAlertCompletion)completion;

+ (void)alert:(NSString *)text title:(NSString *)title cancelButton:(NSString *)cancel successButton:(NSString *)theSuccessButton successCompletion:(SuccessButtonAlertCompletion)completion;

+ (void)alert:(NSString *)text title:(NSString *)title cancelButton:(NSString *)cancel successButton:(NSString *)theSuccessButton withCompletion:(SuccessAndCancelButtonAlertCompletion)completion;

+ (void)alertTextField:(NSString *)text title:(NSString *)title placehodelr:(NSString *)placeholder withOkButton:(NSString *)okButton withCancelButton:(NSString *)cancelButton withCompletion:(TextFieldAlertCompletion)completion;

// Custom Alert

//+ (void)showCustomAlertWithTitle:(NSString *)title
//                     withMessage:(NSString *)message;

//+ (void)showCustomAlertWithTitle:(NSString *)title
//                     withMessage:(NSString *)message
//                  withCompletion:(void(^)(UIButton *sender))completion;

//+ (void)showCustomAlertWithTitle:(NSString *)title
//                     withMessage:(NSString *)message
//               withTitleOkButton:(NSString *)titleOkButton
//                  withCompletion:(void(^)(UIButton *sender))completion;

//+ (void)showCustomAlertWithTitle:(NSString *)title
//                     withMessage:(NSString *)message
//                withOkCompletion:(void(^)(UIButton *sender))okCompletion;

//+ (void)showCustomAlertWithTitle:(NSString *)title
//                     withMessage:(NSString *)message
//                withOkCompletion:(void(^)(UIButton *sender))okCompletion
//            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion;

+ (void)showCustomAlertWithTitle:(NSString *)title
                     withMessage:(NSString *)message
           withCancelButtonTitle:(NSString *)cancelButtonTitle
               withOkButtonTitle:(NSString *)okButtonTitle
                withOkCompletion:(void(^)(UIButton *sender))okCompletion
            withCancelCompletion:(void(^)(UIButton *sender))cancelCompletion
             withYaMaxCompletion:(void(^)(UIButton *sender))yaMaxCompletion;

// Custom Alert with text field

//+ (void)showCustomAlertTextFieldWithTitle:(NSString *)title
//                              withMessage:(NSString *)message
//                          withPlaceholder:(NSString *)placeholder
//                          withButtonTitle:(NSString *)buttonTitle
//                           withCompletion:(void(^)(UIButton *sender, UITextField *testField))completion;
//
//+ (void)showCustomAlertTextFieldWithTitle:(NSString *)title
//                              withMessage:(NSString *)message
//                          withPlaceholder:(NSString *)placeholder
//                        withOkButtonTitle:(NSString *)okButtonTitle
//                    withCancelButtonTitle:(NSString *)cancelButtonTitle
//                         withOkCompletion:(void(^)(UIButton *sender, UITextField *testField))okCompletion
//                     withCancelCompletion:(void(^)(UIButton *sender, UITextField *testField))cancelCompletion;

@end

