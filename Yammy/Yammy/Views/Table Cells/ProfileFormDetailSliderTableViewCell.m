//
//  ProfileFormDetailSliderTableViewCell.m
//  Yammy
//
//  Created by Alex on 3/21/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ProfileFormDetailSliderTableViewCell.h"

@interface ProfileFormDetailSliderTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet CustomButton *saveButton;

@property (assign, nonatomic) BOOL isHeight;
@property (assign, nonatomic) BOOL isPenis;

@end

@implementation ProfileFormDetailSliderTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self.slider setThumbImage:[UIImage imageNamed:@"slider_dot_black"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setupSlider:(BOOL)isHeight {
  self.isHeight = isHeight;
  self.slider.minimumValue = isHeight ? 40.0 : 40.0;
  self.slider.maximumValue = isHeight ? 250.0 : 150.0;
  self.slider.value = [self.value floatValue];
  
  [self prepareTitleLabel:isHeight];
}

- (void)setupPrivateSlider:(BOOL)isPenis {
  self.isPenis = isPenis;
  
  self.slider.minimumValue = isPenis ? 1 : 1;
  self.slider.maximumValue = isPenis ? 40 : 6;
  
  self.slider.value = [self.value floatValue];
  
  [self prepareTitleLabelIsPenis:isPenis];
}

- (void)prepareTitleLabel:(BOOL)isHeight {
  if (isHeight) {
    self.titleLabel.text = [NSString stringWithFormat:@"Около %ld см", (long)[self.value integerValue]];
  } else {
    self.titleLabel.text = [NSString stringWithFormat:@"Около %ld кг", (long)[self.value integerValue]];
  }
}

- (void)prepareTitleLabelIsPenis:(BOOL)isPenis {
  if (isPenis) {
    self.titleLabel.text = [NSString stringWithFormat:@"Около %ld см", (long)[self.value integerValue]];
  } else {
    self.titleLabel.text = [NSString stringWithFormat:@"Около %ld", (long)[self.value integerValue]];
  }
}

- (IBAction)changeValueSlider:(UISlider *)sender {
  self.value = @(sender.value);
  if (self.isPenis) {
    [self prepareTitleLabelIsPenis:self.isPenis];
  } else {
    [self prepareTitleLabel:self.isHeight];
  }
}

- (IBAction)saveDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate saveResultValue:self.value];
  }
}

@end
