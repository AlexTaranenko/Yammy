//
//  HomeCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 06.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  SmallCircleType = 0,
  MediumCircleType,
  HighCircleType
} CircleType;

typedef enum : NSUInteger {
  NoneBezel = 1,
  BorderBezel,
  BorderWithStrawberryBezel,
  PulseBezel
} CircleBezel;

@protocol HomeCollectionViewCellDelegate <NSObject>

@optional

- (void)presentProfileScreenByCell:(UICollectionViewCell *)cell;

@end


@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<HomeCollectionViewCellDelegate> delegate;

- (void)prepareBorderPhotoImageView;

- (void)prepareCornerRadiusForPhotoImageView;

- (void)updatePhotoImageConstraintsByValue:(CGFloat)value;

- (void)hideStrawberryIconImageView:(BOOL)isHide;

- (void)setupPulseAnimation;

- (void)prepareCellByMapping:(ProfileMapping *)profileMapping;

@end

