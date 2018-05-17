//
//  AllOpenProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllOpenProfileCellIdentifier = @"allOpenProfileCell";

@protocol AllOpenProfileTableViewCellDelegate <NSObject>

@optional

- (void)presentPrivateProfileByCell:(UITableViewCell *)cell;

- (void)cancelOpenProfileByCell:(UITableViewCell *)cell;

- (void)acceptOpenProfileByCell:(UITableViewCell *)cell;

@end

@interface AllOpenProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AllOpenProfileTableViewCellDelegate> delegate;

- (void)prepareAllOpenProfileCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

