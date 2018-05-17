//
//  NewRegisterPasswordTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "NewRegisterPasswordTableViewCell.h"

@implementation NewRegisterPasswordTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (IBAction)passwordEditingChanged:(UITextField *)sender {
  self.registerModel.password = sender.text;
}

- (IBAction)confirmPasswordEditingChanged:(UITextField *)sender {
  self.registerModel.confirmPassword = sender.text;
}

@end

