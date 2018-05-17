//
//  ShowingSearchTableViewCell.h
//  Yammy
//
//  Created by Alex on 01.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

typedef enum : NSUInteger {
  AllShowingSearchButtonTag = 0,
  OnlineShowingSearchButtonTag,
  NewShowingSearchButtonTag,
} ShowingSearchButtonTag;

@interface ShowingSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) SearchModel *searchModel;

- (void)prepareShowingButtonsBySearchModel:(SearchModel *)searchModel;

@end

