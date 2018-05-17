//
//  ChatListTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMapping.h"
#import "MGSwipeTableCell.h"

static NSString *const kChatListCellOneIdentifier = @"chatListCellOne";
static NSString *const kChatListCellOneToOneIdentifier = @"chatListCellOneToOne";

@interface ChatListTableViewCell : MGSwipeTableCell

- (void)prepareFromMessageByChatMapping:(ChatMapping *)chatMapping;

- (void)prepareToMessageByChatMapping:(ChatMapping *)chatMapping;

@end

