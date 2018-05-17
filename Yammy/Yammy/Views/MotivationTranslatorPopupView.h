//
//  MotivationTranslatorPopupView.h
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotivationTranslatorPopupViewDelegate <NSObject>

- (void)closeMotivationTranslatorPopupView;

- (void)activateTranslatorMotivationTranslatorPopupView;

@end

@interface MotivationTranslatorPopupView : UIView

@property (weak, nonatomic) id<MotivationTranslatorPopupViewDelegate> delegate;

+ (MotivationTranslatorPopupView *)createMotivationTranslatorPopupView;

@end
