//
//  AgeSearchTableViewCell.h
//  Yammy
//
//  Created by Alex on 31.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "SearchPrivateModel.h"

@interface AgeSearchTableViewCell : UITableViewCell

@property (strong, nonatomic) SearchModel *searchModel;

@property (strong, nonatomic) SearchPrivateModel *searchPrivateModel;

- (void)prepareRangeSliderBySearchModel:(SearchModel *)searchModel;

- (void)prepareRangeSliderBySearchPrivateModel:(SearchPrivateModel *)searchPrivateModel;

@end
