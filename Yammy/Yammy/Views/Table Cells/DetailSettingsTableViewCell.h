//
//  DetailSettingsTableViewCell.h
//  Yammy
//
//  Created by Alex on 3/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailSettingsModel.h"
#import "UserSettingsMapping.h"

static NSString *const kDetailSettingsMoreCellIdentifier = @"detailSettingsMoreCell";
static NSString *const kDetailSettingsCellIdentifier = @"detailSettingsCell";
static NSString *const kDetailSettingsSocialCellIdentifier = @"detailSettingsSocialCell";
static NSString *const kDetailSettingsClearCellIdentifier = @"detailSettingsClearCell";
static NSString *const kDetailSettingsLocationCellIdentifier = @"detailSettingsLocationCell";

@protocol DetailSettingsTableViewCellDelegate <NSObject>

@optional

- (void)changeSwitchByModel:(DetailSettingsModel *)model;

- (void)presentLanguagesVC;

- (void)changeOriginalSwitchByModel:(DetailSettingsModel *)model;

@end


@interface DetailSettingsTableViewCell : UITableViewCell

@property (strong, nonatomic) DetailSettingsModel *model;

@property (strong, nonatomic) UserSettingsMapping *userSettingsMapping;

@property (weak, nonatomic) id<DetailSettingsTableViewCellDelegate> delegate;

- (void)prepareDetailSettingsMoreByModel:(DetailSettingsModel *)detailSettingsModel;

- (void)prepareDetailSettingsByModel:(DetailSettingsModel *)detailSettingsModel;

- (void)prepareLanguageCellByMapping:(UserSettingsMapping *)userSettingsMapping;

@end

