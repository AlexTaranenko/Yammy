//
//  PopupProfileFormTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"
#import "SearchModel.h"

static NSString *const kPopupProfileFormCellIdentifier = @"popupProfileFormCell";
static NSString *const kPopupProfileFormTitleCellIdentifier = @"popupProfileFormTitleCell";
static NSString *const kPopupProfileFormTextFieldCellIdentifier = @"popupProfileFormTextFieldCell";

@interface PopupProfileFormTableViewCell : UITableViewCell

@property (strong, nonatomic) DictionaryMapping *dictionaryMapping;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@property (strong, nonatomic) SearchModel *searchModel;

- (void)prepareTitleByText:(NSString *)title;

- (void)prepareSecondTitleByText:(NSString *)secondTitle;

- (void)prepareInterestIconImageViewBySelected:(BOOL)selected;

- (void)prepareIconImageViewByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel andIndexPath:(NSIndexPath *)indexPath;

- (void)compareFirstId:(NSNumber *)firstId toSecondId:(NSNumber *)secondId;

- (void)prepareSelectPersonIconImageViewBySelected:(BOOL)selected;

- (void)prepareTextFieldByTag:(NSInteger)tag andText:(NSString *)text andPlaceholder:(NSString *)placeholder;

- (void)disabledIconImageView:(BOOL)disable;

@end

