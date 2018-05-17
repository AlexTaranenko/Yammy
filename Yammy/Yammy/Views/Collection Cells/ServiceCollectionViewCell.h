//
//  ServiceCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 19.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ServiceCollectionViewCellDelegate <NSObject>

@optional
- (void)sendServiceByCell:(UICollectionViewCell *)cell;

@end

@interface ServiceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<ServiceCollectionViewCellDelegate> delegate;

- (void)prepareBorderCell;

- (void)prepareServiceCollectionByServicesMapping:(ServicesMapping *)servicesMapping;

- (void)prepareServiceWithSubtitleByServicesMapping:(ServicesMapping *)servicesMapping;

- (void)prepareServiceCollectionByGiftMapping:(GiftMapping *)giftMapping;

@end

