//
//  CoincidenceSearchPrivateTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchPrivateModel.h"

@interface CoincidenceSearchPrivateTableViewCell : UITableViewCell

@property (strong, nonatomic) SearchPrivateModel *searchPrivateModel;

- (void)prepareShowingButtonsBySearchPrivateModel:(SearchPrivateModel *)searchPrivateModel;

@end
