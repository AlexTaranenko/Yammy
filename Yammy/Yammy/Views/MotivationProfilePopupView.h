//
//  MotivationProfilePopupView.h
//  Yammy
//
//  Created by Alex on 5/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kMotivationProfilePopupView = @"MotivationProfilePopupView";
static NSString *kMotivationProfileUploadPhotoPopupView = @"MotivationProfileUploadPhotoPopupView";

@protocol MotivationProfilePopupViewDelegate <NSObject>

- (void)closeMotivationProfilePopup;

- (void)openMotivationProfilePopupGallery;

- (void)openMotivationProfilePopupCamera;

- (void)showMotivationProfilePopupMyProfile;

@end

@interface MotivationProfilePopupView : UIView

@property (weak, nonatomic) id<MotivationProfilePopupViewDelegate> delegate;

+ (MotivationProfilePopupView *)createMotivationProfilePopupView:(NSString *)nibName;

@end
