//
//  BirthdayRegisterTableViewCell.m
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "BirthdayRegisterTableViewCell.h"

@interface BirthdayRegisterTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BirthdayRegisterTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareBirthdayRegisterByModel:(RegisterModel *)registerModel {
  if (registerModel.birthdayUser) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    self.titleLabel.text = [dateFormatter stringFromDate:registerModel.birthdayUser];
  }
}

@end

