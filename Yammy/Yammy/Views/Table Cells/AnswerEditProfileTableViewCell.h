//
//  AnswerEditProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAnswerEditProfileCellIdentifier = @"answerEditProfileCell";

@interface AnswerEditProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *titleText;

- (void)selectedIconImageView:(BOOL)select;

@end
