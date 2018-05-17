//
//  AgeSearchTableViewCell.m
//  Yammy
//
//  Created by Alex on 31.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AgeSearchTableViewCell.h"
#import "BMARangeSlider.h"
#import "BMASliderLiveRenderingStyle.h"

@interface AgeSearchTableViewCell()

@property (weak, nonatomic) IBOutlet BMARangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;

@end

@implementation AgeSearchTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.rangeSlider.style = [[BMASliderLiveRenderingStyle alloc] init];
  //  self.rangeSlider.style.handlerImage = [UIImage imageNamed:@""];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareRangeSliderBySearchModel:(SearchModel *)searchModel {
  [self setupSliderByCurrentLowerValue:searchModel.minAge andCurrentUpperValue:searchModel.maxAge];
  self.rangeLabel.text = [NSString stringWithFormat:@"От %@ до %@", @(self.rangeSlider.currentLowerValue), @(self.rangeSlider.currentUpperValue)];
}

- (void)prepareRangeSliderBySearchPrivateModel:(SearchPrivateModel *)searchPrivateModel {
  [self setupSliderByCurrentLowerValue:searchPrivateModel.minAge andCurrentUpperValue:searchPrivateModel.maxAge];
  self.rangeLabel.text = [NSString stringWithFormat:@"От %@ до %@", @(self.rangeSlider.currentLowerValue), @(self.rangeSlider.currentUpperValue)];
}

- (void)setupSliderByCurrentLowerValue:(NSNumber *)currentLowerValue andCurrentUpperValue:(NSNumber *)currentUpperValue {
  self.rangeSlider.currentLowerValue = [currentLowerValue integerValue];
  self.rangeSlider.currentUpperValue = [currentUpperValue integerValue];
}

- (IBAction)rangeSliderChangeValue:(BMARangeSlider *)sender {
  if (self.searchModel != nil) {
    self.searchModel.minAge = @(self.rangeSlider.currentLowerValue);
    self.searchModel.maxAge = @(self.rangeSlider.currentUpperValue);
    self.rangeLabel.text = [NSString stringWithFormat:@"От %@ до %@", self.searchModel.minAge, self.searchModel.maxAge];
  } else {
    self.searchPrivateModel.minAge = @(self.rangeSlider.currentLowerValue);
    self.searchPrivateModel.maxAge = @(self.rangeSlider.currentUpperValue);
    self.rangeLabel.text = [NSString stringWithFormat:@"От %@ до %@", self.searchPrivateModel.minAge, self.searchPrivateModel.maxAge];
  }
}

@end

