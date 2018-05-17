//
//  ProfileLeftNavButtonView.h
//  Yammy
//
//  Created by Alex on 2/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsButtonViewDelegate <NSObject>

- (void)showSettingsController;

@end

@interface SettingsButtonView : UIView

@property (weak, nonatomic) id<SettingsButtonViewDelegate> delegate;

+ (SettingsButtonView *)setupSettingsButtonView;

@end
