//
//  MotivationPrivateProfilePopupView.h
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationPrivateProfilePopupViewDelegate <NSObject>

- (void)closeMotivationPrivateProfilePopup;

- (void)openPrivateProfileMotivationPrivateProfilePopup;

@end

@interface MotivationPrivateProfilePopupView : UIView

@property (weak, nonatomic) id<MotivationPrivateProfilePopupViewDelegate> delegate;

+ (MotivationPrivateProfilePopupView *)createMotivationPrivateProfilePopupView;

@end
