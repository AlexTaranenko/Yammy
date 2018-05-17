//
//  CreditsCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kCreditsCollectionCellIdentifier = @"creditsCollectionCell";

@protocol CreditsCollectionViewCellDelegate <NSObject>

@optional
- (void)sendCreditByCell:(UICollectionViewCell *)cell;

@end

@interface CreditsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<CreditsCollectionViewCellDelegate> delegate;

- (void)prepareCreditsCollectionCellByGiftMapping:(GiftMapping *)giftMapping;

@end

