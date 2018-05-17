//
//  RequestGiftPrivateProfileView.h
//  Yammy
//
//  Created by Alex on 5/5/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestGiftPrivateProfileViewDelegate <NSObject>

@optional

- (void)cancelRequestGift:(UIButton *)sender;

- (void)acceptRequestGift:(UIButton *)sender;

@end

@interface RequestGiftPrivateProfileView : UIView

@property (weak, nonatomic) id<RequestGiftPrivateProfileViewDelegate> delegate;

+ (RequestGiftPrivateProfileView *)createRequestGiftPrivateProfileView;

- (void)prepareInterfaceByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end
