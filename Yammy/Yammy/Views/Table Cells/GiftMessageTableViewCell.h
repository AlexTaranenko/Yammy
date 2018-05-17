//
//  GiftMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 05.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"

static NSString *kGiftMessageCellIdentifier = @"giftMessageCell";

@protocol GiftMessageTableViewCellDelegate <NSObject>

- (void)presentGiftScreen;

@end

@interface GiftMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) id<GiftMessageTableViewCellDelegate> delegate;

- (void)prepareGiftMessageCellByMessageMapping:(MessageMapping *)messageMapping;

- (void)prepareGiftOutputMessageByMessageMapping:(MessageMapping *)messageMapping;

@end

