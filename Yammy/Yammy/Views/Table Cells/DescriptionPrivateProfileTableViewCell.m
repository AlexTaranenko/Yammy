//
//  DescriptionPrivateProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 12.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "DescriptionPrivateProfileTableViewCell.h"

@interface DescriptionPrivateProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DescriptionPrivateProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setPrivateProfileQuestionsModel:(PrivateProfileQuestionsModel *)privateProfileQuestionsModel {
  NSRange range = [privateProfileQuestionsModel.question rangeOfString:privateProfileQuestionsModel.answer];
  
  NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:privateProfileQuestionsModel.question];
  [mutString addAttributes:@{NSBackgroundColorAttributeName : RGB(235, 235, 235)} range:range];
  self.titleLabel.attributedText = mutString;
}

@end

