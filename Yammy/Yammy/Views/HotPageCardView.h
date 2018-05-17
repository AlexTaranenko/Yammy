//
//  HotPageCardView.h
//  Yammy
//
//  Created by Alex on 2/21/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  OneLockImageViewTag = 10,
  TwoLockImageViewTag,
  ThreeLockImageViewTag,
  FourLockImageViewTag
} LockImageViewTag;

@protocol HotPageCardViewDelegate <NSObject>

@optional

- (void)presentGiftVC;

- (void)sendKingLike;

- (void)presentChatVC;

- (void)selectStrawberryByCustomButton:(CustomButton *)sender;

- (void)presentPhotoBrowser;

- (void)presentProfileVC;

@end

@interface HotPageCardView : UIView

@property (weak, nonatomic) id<HotPageCardViewDelegate> delegate;

+ (HotPageCardView *)setupHotPageCardViewWithFrame:(CGRect)frame;

- (void)prepareHotPageInterfaceByProfileMapping:(ProfileMapping *)profileMapping;

- (void)prepareIconImageViewByImageName:(NSString *)imageName andAlpha:(CGFloat)alpha;

- (void)updateIconImageViewFrameByValue:(CGFloat)value;

@end

