//
//  AnswerEditProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AnswerEditProfileTableViewCell.h"

@interface AnswerEditProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation AnswerEditProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText {
  self.titleLabel.text = titleText;
}

- (void)selectedIconImageView:(BOOL)select {
  if (select) {
    self.iconImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  } else {
    self.iconImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  }
}


@end
