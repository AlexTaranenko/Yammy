//
//  ImageInputMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 12/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"

static NSString *const kImageInputMessageCellIdentifier = @"imageInputMessageCell";

@protocol ImageInputMessageTableViewCellDelegate <NSObject>

@required
- (void)showImageInputMessageByMessageMapping:(MessageMapping *)messageMapping;

@end

@interface ImageInputMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ImageInputMessageTableViewCellDelegate> delegate;

- (void)prepareImageInputMessageByMessageMapping:(MessageMapping *)messageMapping;

@end

