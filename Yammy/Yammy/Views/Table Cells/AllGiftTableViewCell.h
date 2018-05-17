//
//  AllGiftTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAllGiftCellIdentifier = @"allGiftCell";

@interface AllGiftTableViewCell : UITableViewCell

- (void)prepareAllGiftCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

