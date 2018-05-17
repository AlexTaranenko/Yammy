//
//  PopupProfileFormView.h
//  Yammy
//
//  Created by Alex on 10/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

@protocol PopupProfileFormViewDelegate <NSObject>

- (void)dismissPopupProfileFormView;

- (void)selectInterestBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

- (void)selectAnswerBySelectAnswerId:(NSNumber *)answerId andIndexPath:(NSIndexPath *)indexPath;

- (void)selectCharacterBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

- (void)selectInterestedGendersBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

@end

@interface PopupProfileFormView : UIView

@property (weak, nonatomic) id<PopupProfileFormViewDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) NSArray *selectedInterests;

@property (strong, nonatomic) NSArray *answersArray;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

+ (PopupProfileFormView *)createInterestPopupProfileFormView;

+ (PopupProfileFormView *)createPopupProfileFormView;

+ (PopupProfileFormView *)createCharacterPopupProfileFormView;

+ (PopupProfileFormView *)createInterestedGendersPopupProfileFormView;

- (void)loadInterestsByMapping:(InterestsMapping *)interestsMapping;

- (void)loadSelectedTraitsByArray:(NSArray *)selectedTraits;

- (void)loadSelectedGendersByArray:(NSArray *)selectedGenders;

- (void)calculateHeight;

@end

