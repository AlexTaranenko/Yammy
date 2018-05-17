//
//  InterestMeRegisterTableViewCell.m
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "InterestMeRegisterTableViewCell.h"

@interface InterestMeRegisterTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImageView;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIControl *showControl;

@end

@implementation InterestMeRegisterTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText {
  self.showControl.hidden = YES;
  self.titleLabel.text = titleText;
}

- (void)prepareShowControl {
  self.showControl.hidden = NO;
  self.showControl.selected = [self.registerModel.isInterestedGendersHidden boolValue];
  self.showLabel.text = [self.registerModel.isInterestedGendersHidden boolValue] ? @"Открыть" : @"Скрыть";
  
  if ([self.registerModel.isInterestedGendersHidden boolValue]) {
    self.eyeImageView.image = [UIImage imageNamed:@"eye_hide_icon"];
    self.showLabel.textColor = RGB(51, 51, 51);
  } else {
    self.eyeImageView.image = [UIImage imageNamed:@"eye_icon"];
    self.showLabel.textColor = RGB(153, 153, 153);
  }
}

- (IBAction)showDidTap:(UIControl *)sender {
  self.showControl.selected = !sender.selected;
  self.registerModel.isInterestedGendersHidden = @(self.showControl.selected);
  [self prepareShowControl];
}

@end

