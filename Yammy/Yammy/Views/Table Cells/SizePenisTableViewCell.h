//
//  SizePenisTableViewCell.h
//  Yammy
//
//  Created by Alex on 20.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrivateProfileQuestionModel.h"

static NSString *const kSizePenisCellIdentifier = @"sizePenisCell";

@protocol SizePenisTableViewCellDelegate <NSObject>

- (void)finishedSizePenisByCell:(UITableViewCell *)cell;

@end

@interface SizePenisTableViewCell : UITableViewCell

@property (weak, nonatomic) id <SizePenisTableViewCellDelegate> delegate;

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

- (void)prepareSizePenisCellByModel:(MyPrivateProfileQuestionModel *)myPrivateProfileQuestionModel;

@end

