//
//  DetailSettingsTableViewCell.m
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "DetailSettingsTableViewCell.h"

@interface DetailSettingsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchOriginlView;

@end

@implementation DetailSettingsTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareDetailSettingsMoreByModel:(DetailSettingsModel *)detailSettingsModel {
  self.titleLabel.text = detailSettingsModel.titleDetailSettings;
  self.descriptionLabel.text = detailSettingsModel.descriptionDetailSettings;
  [self.switchOriginlView setOn:detailSettingsModel.isOnDetailSettings animated:YES];
  [self changeSwitchOriginalByIsOn:detailSettingsModel.isOnDetailSettings];
}

- (void)prepareDetailSettingsByModel:(DetailSettingsModel *)detailSettingsModel {
  self.titleLabel.text = detailSettingsModel.titleDetailSettings;
  [self.switchOriginlView setOn:detailSettingsModel.isOnDetailSettings animated:YES];
  [self changeSwitchOriginalByIsOn:detailSettingsModel.isOnDetailSettings];
}

- (void)prepareLanguageCellByMapping:(UserSettingsMapping *)userSettingsMapping {
  self.languageNameLabel.text = userSettingsMapping.Language.NativeName ?: @"Выберите язык";
}

- (void)changeSwitchOriginalByIsOn:(BOOL)isOn {
  [self.switchOriginlView setThumbTintColor:isOn ? RGB(249, 0, 64) : RGB(237, 237, 237)];
}

- (IBAction)changeSwitchValue:(UISwitch *)sender {
  self.model.isOnDetailSettings = sender.on;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self changeSwitchOriginalByIsOn:self.model.isOnDetailSettings];
  });
  
  if (self.delegate != nil) {
    [self.delegate changeOriginalSwitchByModel:self.model];
  }
}

- (IBAction)clearDataDidTap:(CustomButton *)sender {
  [UIAlertHelper alert:@"Вы уверены?" title:nil cancelButton:@"Закрыть" successButton:@"Продолжить" withCompletion:^(UIAlertAction *successAction, UIAlertAction *cancelAction) {
    if (successAction) {
      [[ServerManager sharedManager] clearProfileDataWithCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
        [WToast showWithText:@"Данные очищены" duration:5.0];
      }];
    }
  }];
}

- (IBAction)languageDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentLanguagesVC];
  }
}

@end

