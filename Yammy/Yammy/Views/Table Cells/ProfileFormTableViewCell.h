//
//  ProfileFormTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

static NSString *const kProfileFormCellIdentifier = @"profileFormCell";
static NSString *const kAddProfileFormCellIdentifier = @"addProfileFormCell";
static NSString *const kTitleLanguageCellIdentifier = @"titleLanguageCell";

@protocol ProfileFormTableViewCellDelegate <NSObject>

@optional

- (void)deleteLanguageByCell:(UITableViewCell *)cell;

@end

@interface ProfileFormTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ProfileFormTableViewCellDelegate> delegate;

@property (strong, nonatomic) id object;

@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)prepareSelectedIconByUserSettingsMapping:(UserSettingsMapping *)userSettingsMapping;

- (void)prepareSelectedIconByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel;

- (void)compareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId;

- (void)prepareTitleLabelWithMapping:(LanguageMapping *)mapping;

- (void)checkboxCompareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId;

- (void)hiddenDescriptionTextLabel:(BOOL)hidden;

@end

