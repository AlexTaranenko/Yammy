//
//  GiftsViewController.h
//  Yammy
//
//  Created by Alex on 12/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@protocol GiftsViewControllerDelegate <NSObject>

@optional

- (void)reloadGiftsAtTheProfile;

- (void)sendGiftBySelectGiftMapping:(GiftMapping *)giftMapping;

@end

@interface GiftsViewController : UIViewController

@property (strong, nonatomic) ProfileMapping *profileMapping;

@property (weak, nonatomic) id<GiftsViewControllerDelegate> delegate;

@end
