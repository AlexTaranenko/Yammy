//
//  SizeChestTableViewCell.h
//  Yammy
//
//  Created by Alex on 20.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrivateProfileQuestionModel.h"

static NSString *const kSizeChestCellIdentifier = @"sizeChestCell";

@protocol SizeChestTableViewCellDelegate <NSObject>

- (void)finishedSizeChestByCell:(UITableViewCell *)cell;

@end

@interface SizeChestTableViewCell : UITableViewCell

@property (weak, nonatomic) id <SizeChestTableViewCellDelegate> delegate;

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

- (void)prepareSizeChestCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel;

- (void)prepareSizePenisCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel;

@end

