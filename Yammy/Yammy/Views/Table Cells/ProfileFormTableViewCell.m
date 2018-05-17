//
//  ProfileFormTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileFormTableViewCell.h"

typedef enum : NSUInteger {
  RelationsTableViewSection = 0,
  GendersTableViewSection,
  OrientationsTableViewSection,
  InterestedGendersTableViewSection,
  GrowthTableViewSection,
  WeightTableViewSection,
  LiveTableViewSection,
  ChildrenTableViewSection,
  WorkTableViewSection,
  BodyTableViewSection,
  SmokingTableViewSection,
  AlchogolTableViewSection,
  LanguagesTableViewSection,
  QuestionsTableViewSection,
  MoreTableViewSection
} ProfileFormTableViewCellSection;

typedef enum : NSUInteger {
  QuestionWhatForYouLoveRow = 0,
  QuestionWhatFamilyForYouRow,
  QuestionWhatSexForYouRow,
} QuestionsRow;

@interface ProfileFormTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *addedLanguagesTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutAddedLabelTop;

@end

@implementation ProfileFormTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareSelectedIconByUserSettingsMapping:(UserSettingsMapping *)userSettingsMapping {
  self.titleLabel.text = [(LanguageMapping *)self.object NativeName];
  [self compareFirstId:[(LanguageMapping *)self.object IdLanguage] toSecondId:userSettingsMapping.LanguageId];
}

- (void)prepareSelectedIconByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel {
  if ([self.object isKindOfClass:[LanguageMapping class]]) {
    [self prepareSelectIconByLanguageMapping:(LanguageMapping *)self.object andAbouMeModel:publicProfileAboutMeModel];
  } else {
    [self prepareSelectIconByDictioinaryMapping:(DictionaryMapping *)self.object andAbouMeModel:publicProfileAboutMeModel];
  }
}

- (void)prepareSelectIconByDictioinaryMapping:(DictionaryMapping *)mapping andAbouMeModel:(PublicProfileAboutMeModel *)model {
  
  self.titleLabel.text = mapping.Title;
  if (self.indexPath.section == RelationsTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.RelationshipId];
  } else if (self.indexPath.section == GendersTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.SexId];
  } else if (self.indexPath.section == OrientationsTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.GenderId];
  } else if (self.indexPath.section == InterestedGendersTableViewSection) {
    NSArray *filterArray = [model.selectedInterestedGenders filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
    if (filterArray.count > 0) {
      self.iconImageView.image = [UIImage imageNamed:@"selected_checkbox"];
    } else {
      self.iconImageView.image = [UIImage imageNamed:@"select_checkbox"];
    }
  } else if (self.indexPath.section == LiveTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.LiveWithId];
  } else if (self.indexPath.section == ChildrenTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.KidId];
  } else if (self.indexPath.section == WorkTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.JobId];
  } else if (self.indexPath.section == BodyTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.BodyTypeId];
  } else if (self.indexPath.section == SmokingTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.SmokingId];
  } else if (self.indexPath.section == AlchogolTableViewSection) {
    [self selectIconByDictionaryMapping:mapping andAnswerId:model.AlcoholId];
  } else if (self.indexPath.section == MoreTableViewSection) {
    NSArray *filterArray = [model.selectedTraits filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdDictionary == %@", mapping.IdDictionary]];
    if (filterArray.count > 0) {
      self.iconImageView.image = [UIImage imageNamed:@"selected_checkbox"];
    } else {
      self.iconImageView.image = [UIImage imageNamed:@"select_checkbox"];
    }
  }
}

- (void)selectIconByDictionaryMapping:(DictionaryMapping *)mapping andAnswerId:(NSNumber *)answerId {
  [self compareFirstId:mapping.IdDictionary toSecondId:answerId];
}

- (void)prepareSelectIconByLanguageMapping:(LanguageMapping *)languageMapping andAbouMeModel:(PublicProfileAboutMeModel *)model {
  self.titleLabel.text = languageMapping.NativeName;
  [self compareFirstId:languageMapping.IdLanguage toSecondId:model.LanguageId];
}

- (void)compareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId {
  if (secondId != nil && [firstId integerValue] == [secondId integerValue]) {
    self.iconImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  } else {
    self.iconImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  }
}

- (void)checkboxCompareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId {
  if (secondId != nil && [firstId integerValue] == [secondId integerValue]) {
    self.iconImageView.image = [UIImage imageNamed:@"selected_checkbox"];
  } else {
    self.iconImageView.image = [UIImage imageNamed:@"select_checkbox"];
  }
}

- (void)prepareTitleLabelWithMapping:(LanguageMapping *)mapping {
  self.titleLabel.text = mapping.NativeName;
}

- (void)hiddenDescriptionTextLabel:(BOOL)hidden {
    self.addedLanguagesTitleLabel.text = hidden ? nil : @"Я также понимаю (не нужно переводить):";
  self.layoutAddedLabelTop.constant = hidden ? 0 : 10;
}

- (IBAction)deleteLanguageDidTap:(UIControl *)sender {
  if (self.delegate != nil) {
    [self.delegate deleteLanguageByCell:self];
  }
}

- (void)prepareSelectIconBylanguages:(NSArray *)array {
  
  //  array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", self.titleText]];
  //
  //  if (array.count > 0) {
  //    self.iconImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  //  } else {
  //    self.iconImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  //  }
}

@end

