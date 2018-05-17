//
//  PublicProfileGiftsTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kPublicProfileGiftsCellIdentifier = @"publicProfileGiftsCell";

@protocol PublicProfileGiftsTableViewCellDelegate <NSObject>

- (void)presentGiftsWithProfile:(ProfileMapping *)profileMapping;

- (void)presentProfileByMapping:(ProfileMapping *)mapping;

@end

@interface PublicProfileGiftsTableViewCell : UITableViewCell

@property (weak, nonatomic) id<PublicProfileGiftsTableViewCellDelegate> delegate;

- (void)preparePublicProfileGiftsCell:(MyGiftMapping *)myGiftMapping;

@end

