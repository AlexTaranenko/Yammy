//
//  SegmentPrivateProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 9/20/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPrivateProfileQuestionModel.h"

static NSString *const kSegmentPrivateProfileCellIdentifier = @"segmentPrivateProfileCell";
static NSString *const kSegmentPrivateProfileShortCellIdentifier = @"segmentPrivateProfileShortCell";

@protocol SegmentPrivateProfileTableViewCellDelegate <NSObject>

- (void)selectSegmentPrivateProfileByCell:(UITableViewCell *)cell;

@end

@interface SegmentPrivateProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) id <SegmentPrivateProfileTableViewCellDelegate> delegate;

@property (strong, nonatomic) MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel;

- (void)prepareMoreInterface;

- (void)prepareShortIntetface;

@end

