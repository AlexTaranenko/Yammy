//
//  AllInvisibleTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllInvisibleCellIdentifier = @"allInvisibleCell";

@protocol AllInvisibleTableViewCellDelegate <NSObject>

@optional

- (void)presentInvisiblePopup;

@end

@interface AllInvisibleTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AllInvisibleTableViewCellDelegate> delegate;

- (void)prepareAllInvisibleCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

