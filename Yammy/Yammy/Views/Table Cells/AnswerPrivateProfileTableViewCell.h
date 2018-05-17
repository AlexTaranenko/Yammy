//
//  AnswerPrivateProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrivateProfileQuestionModel.h"

static NSString *const kAnswerPrivateProfileCellIdentifier = @"answerPrivateProfileCell";

@interface AnswerPrivateProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

- (void)prepareAnswerPrivateProfileCellByModel:(MyPrivateProfileQuestionModel *)model;

@end
