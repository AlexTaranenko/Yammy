//
//  ProfileFormDetailViewController.h
//  Yammy
//
//  Created by Alex on 3/20/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"
#import "MyPrivateProfileQuestionModel.h"

@protocol ProfileFormDetailViewControllerDelegate <NSObject>

@optional

- (void)selectInterestBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

- (void)selectAnswerBySelectAnswerId:(NSNumber *)answerId andIndexPath:(NSIndexPath *)indexPath;

- (void)selectCharacterBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

- (void)selectInterestedGendersBySelectedArray:(NSArray *)selectedArray andIndexPath:(NSIndexPath *)indexPath;

- (void)reloadTableViewBySelectIndexPath:(NSIndexPath *)indexPath;

- (void)updatePublicProfileByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel;

@end

@interface ProfileFormDetailViewController : UIViewController

@property (weak, nonatomic) id<ProfileFormDetailViewControllerDelegate> delegate;

@property (assign, nonatomic, getter=isAboutMe) BOOL isAboutMe;

@property (assign, nonatomic, getter=isMyName) BOOL isMyName;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (strong, nonatomic) NSArray *selectedInterests;

@property (strong, nonatomic) NSArray *answersArray;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

- (void)loadInterestsByMapping:(InterestsMapping *)interestsMapping;

- (void)loadSelectedTraitsByArray:(NSArray *)selectedTraits;

- (void)loadSelectedGendersByArray:(NSArray *)selectedGenders;

@end
