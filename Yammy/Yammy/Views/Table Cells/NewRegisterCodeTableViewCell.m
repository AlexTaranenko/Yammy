//
//  NewRegisterCodeTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "NewRegisterCodeTableViewCell.h"

@implementation NewRegisterCodeTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
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
  [self endEditing:YES];
  return YES;
}

static NSString* zeroWidthSpace = @"\u200B";

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if ([string isEqualToString:@""]) {
    textField.text = zeroWidthSpace;
    
    // goto prev text field
    NSInteger currentTag = textField.tag;
    NSInteger prevTag = currentTag - 1;
    if(prevTag >= 10)
    {
      UITextField *prevTextField = (UITextField *)[self viewWithTag:prevTag];
      prevTextField.text= zeroWidthSpace;
      [prevTextField becomeFirstResponder];
    }
    
    return NO;
    
  } else {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      self.registerModel.code = [self smsCodeString];
    });
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

@end

