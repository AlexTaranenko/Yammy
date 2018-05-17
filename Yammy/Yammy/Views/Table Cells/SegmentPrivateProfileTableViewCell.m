//
//  SegmentPrivateProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/20/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SegmentPrivateProfileTableViewCell.h"

@interface SegmentPrivateProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collectionMoreButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *collectionButtonsArray;

@end

@implementation SegmentPrivateProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.containerView.layer.borderWidth = 1.f;
  self.containerView.layer.borderColor = RGB(235, 235, 235).CGColor;
  self.containerView.layer.cornerRadius = 5.f;
  self.containerView.clipsToBounds = YES;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public

- (void)prepareMoreInterface {
  self.titleLabel.text = self.myPrivateProfileQuestionModel.question;
  [self prepareButtonsWithButtonsArray:self.collectionMoreButtonsArray];
}

- (void)prepareShortIntetface {
  self.titleLabel.text = self.myPrivateProfileQuestionModel.question;
  [self prepareButtonsWithButtonsArray:self.collectionButtonsArray];
}

#pragma mark - Private

- (void)prepareButtonsWithButtonsArray:(NSArray *)buttonsArray {
  for (UIButton *button in buttonsArray) {
    NSInteger index = [buttonsArray indexOfObject:button];
    DictionaryMapping *dictionaryMapping;
    if (self.myPrivateProfileQuestionModel.answers.count > 0) {
      dictionaryMapping = [self.myPrivateProfileQuestionModel.answers objectAtIndex:index];
      [button setTitle:dictionaryMapping.Title forState:UIControlStateNormal];
    }
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.tag = [dictionaryMapping.IdDictionary integerValue];
    
    if ([self.myPrivateProfileQuestionModel.answer isEqualToString:dictionaryMapping.Title]) {
      button.backgroundColor = RGB(214, 0, 65);
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
      button.backgroundColor = [UIColor clearColor];
      [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    }
  }
}

- (void)chooseAnswerByIndex:(NSInteger)index {
  DictionaryMapping *dictionaryMapping = [self.myPrivateProfileQuestionModel.answers objectAtIndex:index - 1];
  self.myPrivateProfileQuestionModel.answer = dictionaryMapping.Title;
}

- (IBAction)moreButtonDidTap:(UIButton *)sender {
  [self chooseAnswerByIndex:sender.tag];
  [self prepareMoreInterface];
  if (self.delegate != nil) {
    [self.delegate selectSegmentPrivateProfileByCell:self];
  }
}

- (IBAction)shortButtonDidTap:(UIButton *)sender {
  [self chooseAnswerByIndex:sender.tag];
  [self prepareShortIntetface];
  if (self.delegate != nil) {
    [self.delegate selectSegmentPrivateProfileByCell:self];
  }
}

@end

