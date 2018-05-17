//
//  AllRequestProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 4/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kAllRequestProfileCellIdentifier = @"allRequestProfileCell";

@protocol AllRequestProfileTableViewCellDelegate <NSObject>

- (void)cancelRequest:(UITableViewCell *)cell;

- (void)showGifts:(UITableViewCell *)cell;

- (void)showChat:(UITableViewCell *)cell;

- (void)acceptRequest:(UITableViewCell *)cell;

- (void)showProfile:(UITableViewCell *)cell;

@end

@interface AllRequestProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) id<AllRequestProfileTableViewCellDelegate> delegate;

- (void)prepareAllRequestProfileByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end
