//
//  BlockedCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kBlockedCollectionCellIdentifier = @"blockedCollectionCell";

@protocol BlockedCollectionViewCellDelegate <NSObject>

@optional

- (void)showProfileByCollectionCell:(UICollectionViewCell *)collectionCell;

- (void)unlockUserByCollectionCell:(UICollectionViewCell *)collectionCell;

@end

@interface BlockedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<BlockedCollectionViewCellDelegate> delegate;

- (void)prepareBlockedCollectionCellByProfileMapping:(ProfileMapping *)profileMapping;

@end
