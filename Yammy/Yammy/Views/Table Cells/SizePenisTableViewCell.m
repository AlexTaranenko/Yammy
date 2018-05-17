//
//  SizePenisTableViewCell.m
//  Yammy
//
//  Created by Alex on 20.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SizePenisTableViewCell.h"
#import "BMARangeSlider.h"

@interface SizePenisTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet BMARangeSlider *slider;

@end

@implementation SizePenisTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self.slider addTarget:self action:@selector(endEditingSizePenis) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareSizePenisCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel {
  self.titleLabel.text = myPrivateProfileQuestionModel.question;
  
  if (myPrivateProfileQuestionModel.answer == nil) {
    NSString *answerFromArray = [myPrivateProfileQuestionModel.answers firstObject];
    [self setupSliderByString:answerFromArray];
  } else {
    [self setupSliderByString:myPrivateProfileQuestionModel.answer];
  }
}

- (void)setupSliderByString:(NSString *)answer {
  NSArray *components = [answer componentsSeparatedByString:@"-"];
  NSNumber *currentLowerValue = (NSNumber *)[components firstObject];
  NSNumber *currentUpperValue = (NSNumber *)[components lastObject];
  
  self.slider.currentLowerValue = [currentLowerValue integerValue];
  self.slider.currentUpperValue = [currentUpperValue integerValue];
  
  [self answerByCurrentLowerValue:[currentLowerValue integerValue] andCurrentUpperValue:[currentUpperValue integerValue]];
}

- (void)answerByCurrentLowerValue:(CGFloat)currentLowerValue andCurrentUpperValue:(CGFloat)currentUpperValue {
  NSString *answer = [NSString stringWithFormat:@"%@-%@", @(currentLowerValue), @(currentUpperValue)];
  self.myPrivateProfileQuestionModel.answer = answer;
  self.sizeLabel.text = answer;
}

- (void)endEditingSizePenis {
  if (self.delegate != nil) {
    [self.delegate finishedSizePenisByCell:self];
  }
}

- (IBAction)sizePenisChangeValue:(BMARangeSlider *)sender {
  [self answerByCurrentLowerValue:sender.currentLowerValue andCurrentUpperValue:sender.currentUpperValue];
}

@end

