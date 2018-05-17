//
//  RequestShowPrivateProfileView.h
//  Yammy
//
//  Created by Alex on 4/26/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RequestShowPrivateProfileViewDelegate <NSObject>

@optional

- (void)showGiftsScreen:(CustomButton *)sender;

- (void)sendRequestProfile:(UIButton *)sender;

- (void)cancelSendRequest:(UIButton *)sender;

@end


@interface RequestShowPrivateProfileView : UIView

@property (weak, nonatomic) id<RequestShowPrivateProfileViewDelegate> delegate;

@property (assign, nonatomic) BOOL isRequest;

+ (RequestShowPrivateProfileView *)createRequestShowPrivateProfileView;

- (void)prepareInterfaceByProfileMapping:(ProfileMapping *)profileMapping;

- (void)prepareInterfaceByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end
