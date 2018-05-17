//
//  StickerMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kStickerInputMessageCellIdentifier = @"stickerInputMessageCell";
static NSString *const kStickerOutputMessageCellIdentifier = @"stickerOutputMessageCell";

@interface StickerMessageTableViewCell : UITableViewCell

- (void)prepareStickerMessageByMessageMapping:(MessageMapping *)messageMapping;

@end

