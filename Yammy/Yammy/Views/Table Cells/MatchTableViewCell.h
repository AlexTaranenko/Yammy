//
//  MatchTableViewCell.h
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchMapping.h"
#import "ActivityLineMapping.h"

static NSString *const kMatchCellIdentifier = @"matchCell";

@protocol MatchTableViewCellDelegate <NSObject>

@optional

- (void)openMatchChatByCell:(UITableViewCell *)cell;

- (void)openMatchPublicProfileByCell:(UITableViewCell *)cell;

@end

@interface MatchTableViewCell : UITableViewCell

@property (weak, nonatomic) id<MatchTableViewCellDelegate> delegate;

- (void)prepareMatchCellByMapping:(MatchMapping *)matchMapping;

- (void)prepareMatchCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

