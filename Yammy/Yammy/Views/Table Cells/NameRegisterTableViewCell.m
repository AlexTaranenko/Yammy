//
//  NameRegisterTableViewCell.m
//  Yammy
//
//  Created by Alex on 31.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "NameRegisterTableViewCell.h"

@interface NameRegisterTableViewCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation NameRegisterTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Ваше имя" attributes:@{NSForegroundColorAttributeName : RGB(51, 51, 51), NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:17.f]}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)prepareNameRegisterByModel:(RegisterModel *)registerModel {
  self.nameTextField.text = registerModel.nameUser;
}

- (IBAction)editingChangedValue:(UITextField *)sender {
  self.registerModel.nameUser = sender.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.nameTextField resignFirstResponder];
  return YES;
}

@end

