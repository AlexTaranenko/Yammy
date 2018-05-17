//
//  MotivationInvisiblePopupView.h
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationInvisiblePopupViewDelegate <NSObject>

- (void)activateInvisibleMotivationInvisiblePopupView;

- (void)closeMotivationInvisiblePopupView;

@end

@interface MotivationInvisiblePopupView : UIView

@property (weak, nonatomic) id<MotivationInvisiblePopupViewDelegate> delegate;

+ (MotivationInvisiblePopupView *)createMotivationInvisiblePopupView;

@end
