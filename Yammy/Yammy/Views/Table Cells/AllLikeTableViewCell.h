//
//  AllLikeTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeMapping.h"
#import "ActivityLineMapping.h"

typedef enum : NSUInteger {
  SmallLikeType = 0,
  DoubleLikeType,
  BigLikeType,
  NoneLikeType
} LikeType;

static NSString *const kAllLikeCellIdentifier = @"allLikeCell";

@interface AllLikeTableViewCell : UITableViewCell

- (void)prepareAllLikeByMapping:(LikeMapping *)likeMapping;

- (void)prepareAllLikeByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

