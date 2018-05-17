//
//  TextOutputMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 11/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"

static NSString *kTextOutputMessageCellIdentifier = @"textOutputMessageCell";

@protocol TextOutputMessageTableViewCellDelegate <NSObject>

@optional

- (void)resendTextMessage:(UITableViewCell *)cell;

@end

@interface TextOutputMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<TextOutputMessageTableViewCellDelegate> delegate;

- (void)prepareCellByMessageMapping:(MessageMapping *)messageMapping;

@end

