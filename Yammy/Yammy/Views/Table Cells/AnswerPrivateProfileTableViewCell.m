//
//  AnswerPrivateProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AnswerPrivateProfileTableViewCell.h"

@interface AnswerPrivateProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation AnswerPrivateProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAnswerPrivateProfileCellByModel:(MyPrivateProfileQuestionModel *)model {
  self.questionLabel.text = model.question;
  self.answerLabel.text = model.answer != nil ? model.answer : @"Не заполнено";
}

@end

