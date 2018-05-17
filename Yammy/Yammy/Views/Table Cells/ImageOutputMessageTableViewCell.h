//
//  ImageOutputMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 12/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"

static NSString *const kImageOutputMessageCellIdentifier = @"imageOutputMessageCell";

@protocol ImageOutputMessageTableViewCellDelegate <NSObject>

@required
- (void)showImageOutputMessageByMessageMapping:(MessageMapping *)messageMapping;

@optional

- (void)resendImageMessage;

@end

@interface ImageOutputMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<ImageOutputMessageTableViewCellDelegate> delegate;

- (void)prepareImageOutputMessageByMessageMapping:(MessageMapping *)messageMapping;

@end

