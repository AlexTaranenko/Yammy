//
//  CountrySearchTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CountrySearchTableViewCell.h"

@interface CountrySearchTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation CountrySearchTableViewCell

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

- (IBAction)selectControlDidTap:(UIControl *)sender {
  if (self.delegate != nil) {
    [self.delegate selectLocationByCell:self];
  }
}

@end

