//
//  HotPageCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 10/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kHotPageCollectionCellIdentifier = @"hotPageCollectionCell";

@protocol HotPageCollectionViewCellDelegate <NSObject>

@optional
- (void)selectItemByCell:(UICollectionViewCell *)collectionCell;

@end

@interface HotPageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<HotPageCollectionViewCellDelegate> delegate;

- (void)prepareCornerRadius;

- (void)prepareCollectionView;

- (void)reloadCollectionViewByArray:(NSArray *)imagesArray;

@end

