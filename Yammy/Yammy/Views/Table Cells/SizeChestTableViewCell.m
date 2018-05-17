//
//  SizeChestTableViewCell.m
//  Yammy
//
//  Created by Alex on 20.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SizeChestTableViewCell.h"
#import "BMASlider.h"

@interface SizeChestTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet BMASlider *sizeSlider;

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation SizeChestTableViewCell

- (NSNumberFormatter *)numberFormatter {
  if (_numberFormatter == nil) {
    _numberFormatter = [NSNumberFormatter new];
    _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
  }
  return _numberFormatter;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self.sizeSlider addTarget:self action:@selector(endEditingSizeChest) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareSizeChestCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel {
  self.sizeSlider.minimumValue = 1;
  self.sizeSlider.maximumValue = 6;
  [self setupValuesByModel:myPrivateProfileQuestionModel];
}

- (void)prepareSizePenisCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel {
  self.sizeSlider.minimumValue = 10;
  self.sizeSlider.maximumValue = 30;
  [self setupValuesByModel:myPrivateProfileQuestionModel];
}

- (void)setupSizeByNumber:(NSNumber *)value {
  self.myPrivateProfileQuestionModel.answer = [NSString stringWithFormat:@"%@", value];
  self.sizeSlider.currentValue = [value integerValue];
  self.sizeLabel.text = self.myPrivateProfileQuestionModel.answer;
}

- (void)setupValuesByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel {
  self.titleLabel.text = myPrivateProfileQuestionModel.question;
  
  NSNumber *value = nil;
  if (myPrivateProfileQuestionModel.answer == nil) {
    value = [myPrivateProfileQuestionModel.answers firstObject];
  } else {
    value = [self.numberFormatter numberFromString:myPrivateProfileQuestionModel.answer];
  }
  [self setupSizeByNumber:value];
}

- (void)endEditingSizeChest {
  if (self.delegate != nil) {
    [self.delegate finishedSizeChestByCell:self];
  }
}

- (IBAction)sizeChestChangeValue:(BMASlider *)sender {
  [self setupSizeByNumber:@(sender.currentValue)];
}

@end

