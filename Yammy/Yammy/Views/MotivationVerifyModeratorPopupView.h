//
//  MotivationVerifyModeratorPopupView.h
//  Yammy
//
//  Created by Alex on 5/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationVerifyModeratorPopupViewDelegate <NSObject>

- (void)closeMotivationVerifyModeratorPopup;

- (void)selectCustomButtonByAdTypes:(AdTypes)adTypes;

@end

@interface MotivationVerifyModeratorPopupView : UIView

@property (weak, nonatomic) id<MotivationVerifyModeratorPopupViewDelegate> delegate;

+ (MotivationVerifyModeratorPopupView *)createMotivationVerifyModeratorPopupViewByAdType:(AdTypes)adTypes;

@end
