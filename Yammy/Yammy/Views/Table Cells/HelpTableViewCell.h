//
//  HelpTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleModel.h"

static NSString *const kHelpCellIdentifier = @"helpCell";

@interface HelpTableViewCell : UITableViewCell

- (void)prepareHelpCellByHelpMapping:(HelpMapping *)helpMapping;

- (void)prepareHelpCellByArticleModel:(ArticleModel *)articleModel;

@end

