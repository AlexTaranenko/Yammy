//
//  NewRegisterNameTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "NewRegisterNameTableViewCell.h"

@implementation NewRegisterNameTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.nameTextField.placeholder = @"Email или Телефон";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (IBAction)nameChanged:(UITextField *)sender {
  self.registerModel.nameUser = sender.text;
}

@end
