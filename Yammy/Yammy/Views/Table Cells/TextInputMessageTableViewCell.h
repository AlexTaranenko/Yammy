//
//  TextInputMessageTableViewCell.h
//  Yammy
//
//  Created by Alex on 11/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageMapping.h"

static NSString *const kTextInputMessageCellIdentifier = @"textInputMessageCell";

@interface TextInputMessageTableViewCell : UITableViewCell

- (void)prepareCellByMessageMapping:(MessageMapping *)messageMapping;

@end

