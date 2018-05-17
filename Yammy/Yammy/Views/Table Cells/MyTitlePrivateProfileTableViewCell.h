//
//  MyTitlePrivateProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTitlePrivateProfileModel.h"

static NSString *const kMyTitlePrivateProfileCellIdentifier = @"myTitlePrivateProfileCell";

@interface MyTitlePrivateProfileTableViewCell : UITableViewCell

@property (strong, nonatomic) MyTitlePrivateProfileModel *myTitlePrivateProfileModel;

- (void)prepareMyTitlePrivateProfileCellWithModel:(MyTitlePrivateProfileModel *)myTitlePrivateProfileModel;

@end
