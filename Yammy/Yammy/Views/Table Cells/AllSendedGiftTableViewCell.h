//
//  AllSendedGiftTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllSendedGiftCellIdentifier = @"allSendedGiftCell";

@protocol AllSendedGiftTableViewCellDelegate <NSObject>

@optional

- (void)sendGiftByCell:(UITableViewCell *)cell;

- (void)openProfileAllSendedGiftByCell:(UITableViewCell *)cell;

@end

@interface AllSendedGiftTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AllSendedGiftTableViewCellDelegate> delegate;

- (void)prepareAllSendedGiftByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

