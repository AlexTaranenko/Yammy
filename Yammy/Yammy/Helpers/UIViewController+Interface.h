//
//  UIViewController+Interface.h
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"
#import "MotivationPopupView.h"
#import "TutorialViewController.h"

@interface UIViewController (Interface)<MotivationPopupViewDelegate>

@property (strong, nonatomic) MotivationPopupView *motivationPopupView;

- (UIButton *)getCenterButton;

- (void)prepareCancelBarButtonItem;

- (void)prepareRightCancelBarButtonItem;

- (void)prepareBackBarButtonItem;

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (BOOL)tabBarIsVisible;

- (void)setupTitleNavigationViewWithImageName:(NSString *)imageName;

- (void)presentProfileByProfileMapping:(ProfileMapping *)profileMapping;

- (void)presentReportAlertByProfileMapping:(ProfileMapping *)profileMapping;

- (void)presentShareControllerByProfileMapping:(ProfileMapping *)profileMapping;

- (void)presentRecoveryPasswordControllerByLoginModel:(LoginModel *)loginModel orRegisterModel:(RegisterModel *)registerModel;

- (void)presentFullImageControllerByPhotos:(NSArray *)photos andIsMyProfile:(BOOL)isMyProfile andIndex:(NSIndexPath *)indexPath;

- (void)presentServicesScreen;

- (void)presentPrivateProfileByMapping:(ProfileMapping *)profileMapping;

- (void)presentMotivationByPage:(MotivationPage)motivationPage;

- (void)dismissMotivationByPage;

- (void)presentTutorialScreenByType:(TutorialType)tutorialType;

@end

