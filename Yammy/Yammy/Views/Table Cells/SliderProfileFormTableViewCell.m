//
//  SliderProfileFormTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SliderProfileFormTableViewCell.h"
#import "BMASlider.h"

@interface SliderProfileFormTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet BMASlider *sizeSlider;

@end

@implementation SliderProfileFormTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareTitleLabelByTitleText:(NSString *)titleText {
  self.titleLabel.text = titleText;
}

- (void)setupSliderCurrantValue:(CGFloat)currentValue {
  self.sizeSlider.currentValue = currentValue;
  if (self.isGrowth) {
    [self prepareGrowthSizeLabelBiSize:(NSInteger)currentValue];
  } else {
    [self prepareWeightSizeLabelBiSize:(NSInteger)currentValue];
  }
}

- (void)prepareWeightSizeLabelBiSize:(NSInteger)size {
  self.sizeLabel.text = [NSString stringWithFormat:@"%ld кг",(long)size];
}

- (void)prepareGrowthSizeLabelBiSize:(NSInteger)size {
  self.sizeLabel.text = [NSString stringWithFormat:@"%ld см",(long)size];
}

- (IBAction)sizeChanged:(BMASlider *)sender {
  if (self.isGrowth) {
    self.publicProfileAboutMeModel.Height = @(sender.currentValue);
    [self prepareGrowthSizeLabelBiSize:(NSInteger)sender.currentValue];
  } else {
    self.publicProfileAboutMeModel.Weight = @(sender.currentValue);
    [self prepareWeightSizeLabelBiSize:(NSInteger)sender.currentValue];
  }
}

@end

