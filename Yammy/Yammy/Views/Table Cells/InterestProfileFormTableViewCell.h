//
//  InterestProfileFormTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kInterestProfileFormCellIdentifier = @"interestProfileFormCell";

@interface InterestProfileFormTableViewCell : UITableViewCell

- (void)prepareInterestProfileCellByMapping:(InterestsMapping *)mapping;

- (void)prepareAnswerByArray:(NSArray *)array;

@end

