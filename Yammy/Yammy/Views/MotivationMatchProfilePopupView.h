//
//  MotivationPrivateProfilePopupView.h
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationMatchProfilePopupViewDelegate <NSObject>

- (void)closeMotivationMatchProfilePopup;

- (void)openChatMotivationMatchProfilePopup:(MatchMapping *)matchMapping;

@end

@interface MotivationMatchProfilePopupView : UIView

@property (weak, nonatomic) id<MotivationMatchProfilePopupViewDelegate> delegate;

+ (MotivationMatchProfilePopupView *)createMotivationPrivateProfilePopupView;

- (void)prepareInterfaceByMatchMapping:(MatchMapping *)matchMapping;

@end
