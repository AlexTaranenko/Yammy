//
//  GiftCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 19.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftMapping.h"

@protocol GiftCollectionViewCellDelegate <NSObject>

@optional
- (void)sendGiftByCell:(UICollectionViewCell *)cell;

@end

@interface GiftCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<GiftCollectionViewCellDelegate> delegate;

- (void)prepareBorderCell;

- (void)prepareGiftCollectionByUserGiftMapping:(UserGiftMapping *)userGiftMapping;

- (void)prepareGiftCollectionByGiftMapping:(GiftMapping *)giftMapping;

@end

