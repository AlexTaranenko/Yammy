//
//  ProfileFormQuestionAnswerTableViewCell.h
//  Yammy
//
//  Created by Alex on 15.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

typedef enum : NSUInteger {
  GenderControlTag = 10,
  InterestedGenderControlTag
} ControlTag;

static NSString *const kProfileFormQuestionAnswerCellIdentifier = @"profileFormQuestionAnswerCell";

@interface ProfileFormQuestionAnswerTableViewCell : UITableViewCell

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

- (void)prepareShowHideControlByTag:(NSInteger)tag;

- (void)prepareQuestion:(NSString *)question andAnswer:(NSString *)answer;

- (void)prepareQuestion:(NSString *)question withAnswerId:(NSNumber *)answerId andAnswersArray:(NSArray *)answersArray;

- (void)prepareQuestion:(NSString *)question withSelectedItemsArray:(NSArray *)selectedItemsArray;

@end

