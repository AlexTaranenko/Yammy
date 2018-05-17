//
//  ProfileFormQuestionAnswerTableViewCell.m
//  Yammy
//
//  Created by Alex on 15.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileFormQuestionAnswerTableViewCell.h"

@interface ProfileFormQuestionAnswerTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIControl *showHideControl;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eyeImageView;

@end

@implementation ProfileFormQuestionAnswerTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareShowHideControlByTag:(NSInteger)tag {
  self.showHideControl.tag = tag;
  self.showHideControl.hidden = NO;
  
  self.showHideControl.selected = [self checkIsOpenByTag:@(self.showHideControl.tag)];
  self.showLabel.text = [self checkIsOpenByTag:@(self.showHideControl.tag)] ? @"Открыть" : @"Скрыть";
  
  if ([self checkIsOpenByTag:@(self.showHideControl.tag)]) {
    self.eyeImageView.image = [UIImage imageNamed:@"eye_hide_icon"];
    self.showLabel.textColor = RGB(51, 51, 51);
  } else {
    self.eyeImageView.image = [UIImage imageNamed:@"eye_icon"];
    self.showLabel.textColor = RGB(153, 153, 153);
  }
}

- (BOOL)checkIsOpenByTag:(NSNumber *)tag {
  if ([tag integerValue] == GenderControlTag) {
    return [self.publicProfileAboutMeModel.IsGenderHidden boolValue];
  } else {
    return [self.publicProfileAboutMeModel.IsInterestedGendersHidden boolValue];
  }
}

- (void)prepareQuestion:(NSString *)question andAnswer:(NSString *)answer {
  self.showHideControl.hidden = YES;
  self.questionLabel.text = question;
  self.answerLabel.text = answer;
}

- (void)prepareQuestion:(NSString *)question withAnswerId:(NSNumber *)answerId andAnswersArray:(NSArray *)answersArray {
  self.showHideControl.hidden = YES;
  self.questionLabel.text = question;
  self.answerLabel.text = @"Не заполнено";
  
  if (answersArray.count > 0) {
    id object = [answersArray firstObject];
    if ([object isKindOfClass:[DictionaryMapping class]]) {
      NSArray *filterdArray = [answersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", answerId]];
      if (filterdArray.count > 0) {
        DictionaryMapping *dictionaryMapping = (DictionaryMapping *)[filterdArray firstObject];
        self.answerLabel.text = dictionaryMapping.Title;
      }
    } else {
      NSArray *filterdArray = [answersArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdLanguage == %@", answerId]];
      if (filterdArray.count > 0) {
        LanguageMapping *languageMapping = (LanguageMapping *)[filterdArray firstObject];
        self.answerLabel.text = languageMapping.NativeName;
      }
    }
  }
}

- (void)prepareQuestion:(NSString *)question withSelectedItemsArray:(NSArray *)selectedItemsArray {
  self.questionLabel.text = question;
  self.answerLabel.text = @"Не заполнено";
  self.showHideControl.hidden = YES;
  
  if (selectedItemsArray.count > 0) {
    NSMutableString *mutString = [NSMutableString new];
    for (DictionaryMapping *mapping in selectedItemsArray) {
      [mutString appendString:mapping.Title];
      NSInteger index = [selectedItemsArray indexOfObject:mapping];
      if (index + 1 != selectedItemsArray.count) {
        [mutString appendString:@", "];
      }
    }
    
    self.answerLabel.text = mutString;
  }
}

- (IBAction)showHideDidTap:(UIControl *)sender {
  
  self.showHideControl.selected = !sender.selected;
  
  if (sender.tag == GenderControlTag) {
    self.publicProfileAboutMeModel.IsGenderHidden = @(self.showHideControl.selected);
  } else {
    self.publicProfileAboutMeModel.IsInterestedGendersHidden = @(self.showHideControl.selected);
  }
  
  [self prepareShowHideControlByTag:self.showHideControl.tag];
}

@end

