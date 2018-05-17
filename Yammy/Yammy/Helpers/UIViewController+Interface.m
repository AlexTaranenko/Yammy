//
//  UIViewController+Interface.m
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UIViewController+Interface.h"
#import "ProfileViewController.h"
#import "ReportViewController.h"
#import "RecoveryPasswordViewController.h"
#import "FullImageViewController.h"
#import "MyPublicProfileViewController.h"
#import "ServicesViewController.h"
#import "PrivateProfileViewController.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static void *AssociationMotivationPopupView = &AssociationMotivationPopupView;

@implementation UIViewController (Interface)

- (MotivationPopupView *)motivationPopupView {
  return objc_getAssociatedObject(self, AssociationMotivationPopupView);
}

- (void)setMotivationPopupView:(MotivationPopupView *)motivationPopupView {
  objc_setAssociatedObject(self, &AssociationMotivationPopupView, motivationPopupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)prepareCancelBarButtonItem {
  [self hideLeftButton];
  
  UIButton *backBtn = [self setupCancelButtonWithImageName:@"cancel_icon"];
  if ([self respondsToSelector:@selector(cancelButtonDidTap:)]) {
    [backBtn addTarget:self action:@selector(cancelButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  [self.navigationItem setLeftBarButtonItem:leftBtn];
}

- (void)prepareRightCancelBarButtonItem {
  self.navigationItem.rightBarButtonItem = nil;
  
  UIButton *backBtn = [self setupCancelButtonWithImageName:@"cancel_icon"];
  if ([self respondsToSelector:@selector(rightBackButtonDidTap:)]) {
    [backBtn addTarget:self action:@selector(rightBackButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  [self.navigationItem setRightBarButtonItem:rightBtn];
}

- (UIButton *)setupCancelButtonWithImageName:(NSString *)imageName {
  UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
  [backBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
  return backBtn;
}

- (void)prepareBackBarButtonItem {
  [self hideLeftButton];
  
  UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
  [backBtn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
  
  if ([self respondsToSelector:@selector(backButtonDidTap:)]) {
    [backBtn addTarget:self action:@selector(backButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  NSLayoutConstraint * heightConstraint = [backBtn.heightAnchor constraintEqualToConstant:30];
  NSLayoutConstraint * widthConstraint = [backBtn.widthAnchor constraintEqualToConstant:30];
  [widthConstraint setActive:YES];
  [heightConstraint setActive:YES];
  
  UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
  [self.navigationItem setLeftBarButtonItem:leftBtn];
}

- (void)hideLeftButton {
  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.leftItemsSupplementBackButton = YES;
  self.navigationController.navigationBar.hidden = NO;
}

- (UIButton *)getCenterButton {
  
  UIButton *button = nil;
  for (id object in [DELEGATE.window.rootViewController.view subviews]) {
    if ([object isKindOfClass:[UIButton class]]) {
      button = (UIButton *)object;
      if (button.tag == kCenterButtonTag) {
        break;
      }
    }
  }
  
  return button;
}

- (void)presentReportAlertByProfileMapping:(ProfileMapping *)profileMapping {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Report" andStoryboardId:REPORT_STORYBOARD_ID];
  ReportViewController *reportViewController = (ReportViewController *)[navVC topViewController];
  reportViewController.profileMapping = profileMapping;
  [self.navigationController pushViewController:reportViewController animated:YES];
}

#pragma mark - Tab Bar

// pass a param to describe the state change, an animated flag and a completion block matching UIView animations completion
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
  
  // bail if the current state matches the desired state
  if ([self tabBarIsVisible] == visible) return (completion)? completion(YES) : nil;
  
  // get a frame calculation ready
  CGRect frame = self.tabBarController.tabBar.frame;
  CGFloat height = frame.size.height;
  CGFloat offsetY = (visible)? -height : height;
  
  UIButton *centerButton = [self getCenterButton];
  CGRect frameCenterButton = centerButton.frame;
  CGFloat heightButton = frameCenterButton.size.height + 3;
  CGFloat offsetButtonY = (visible)? -heightButton : heightButton;
  
  // zero duration means no animation
  CGFloat duration = (animated)? 0.3: 0.0;
  
  [UIView animateWithDuration:duration animations:^{
    self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    centerButton.frame = CGRectOffset(frameCenterButton, 0, offsetButtonY);
    
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
  } completion:completion];
}

//Getter to know the current state
- (BOOL)tabBarIsVisible {
  return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

- (void)setupTitleNavigationViewWithImageName:(NSString *)imageName {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110, 34)];
  UIImageView *imgView = [[UIImageView alloc] initWithFrame:view.bounds];
  imgView.contentMode = UIViewContentModeScaleToFill;
  imgView.image = [UIImage imageNamed:imageName];
  view.backgroundColor = [UIColor clearColor];
  [view addSubview:imgView];
  self.navigationItem.titleView = view;
}

- (void)presentProfileByProfileMapping:(ProfileMapping *)profileMapping {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = profileMapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)presentShareControllerByProfileMapping:(ProfileMapping *)profileMapping {
  //  NSString *textShare = @"Test text ...";
  NSURL *myWebsite;
  if (profileMapping == nil) {
    myWebsite = [NSURL URLWithString:@"http://yammydating.com/"];
  } else {
    myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"http://yammydating.com/web/profile/%@", profileMapping.UserId]];
  }
  //  UIImage *image = [UIImage imageNamed:@"placeholder_image"];
  
  NSArray *objectsToShare = @[myWebsite];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
  
  NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                 UIActivityTypePrint,
                                 UIActivityTypeAssignToContact,
                                 UIActivityTypeSaveToCameraRoll,
                                 UIActivityTypeAddToReadingList,
                                 UIActivityTypePostToFlickr,
                                 UIActivityTypePostToVimeo,
                                 UIActivityTypeCopyToPasteboard];
  
  activityVC.excludedActivityTypes = excludeActivities;
  
  [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)presentRecoveryPasswordControllerByLoginModel:(LoginModel *)loginModel orRegisterModel:(RegisterModel *)registerModel {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"RecoveryPassword" andStoryboardId:RECOVERY_PASSWORD_STORYBOARD_ID];
  RecoveryPasswordViewController *recoveryPasswordVC = (RecoveryPasswordViewController *)[navVC topViewController];
  recoveryPasswordVC.loginModel = loginModel;
  recoveryPasswordVC.registerModel = registerModel;
  [self.navigationController pushViewController:recoveryPasswordVC animated:YES];
}

- (void)presentFullImageControllerByPhotos:(NSArray *)photos andIsMyProfile:(BOOL)isMyProfile andIndex:(NSIndexPath *)indexPath {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"FullImage" andStoryboardId:FULL_IMAGE_STORYBOARD_ID];
  FullImageViewController *fullImageVC = (FullImageViewController *)[navVC topViewController];
  fullImageVC.photosArray = [NSMutableArray arrayWithArray:photos];
  fullImageVC.isMyProfile = isMyProfile;
  fullImageVC.indexPath = indexPath;
  if (fullImageVC.isMyProfile) {
    if ([self isKindOfClass:[MyPublicProfileViewController class]]) {
      fullImageVC.isMyPublicProfile = YES;
    } else {
      fullImageVC.isMyPublicProfile = NO;
    }
  }
  [self presentViewController:navVC animated:YES completion:nil];
}

- (void)presentServicesScreen {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Services" andStoryboardId:SERVICES_STORYBOARD_ID];
    ServicesViewController *servicesVC = (ServicesViewController *)[navVC topViewController];
    [self.navigationController pushViewController:servicesVC animated:YES];
  });
}

- (void)presentPrivateProfileByMapping:(ProfileMapping *)profileMapping {
  PrivateProfileViewController *privateProfileVC = (PrivateProfileViewController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_PRIVATE_CONTAINER_SEGUE];
  privateProfileVC.profileMapping = profileMapping;
  privateProfileVC.isShowPirvateProfile = YES;
  [self.navigationController pushViewController:privateProfileVC animated:YES];
}

- (void)presentMotivationByPage:(MotivationPage)motivationPage {
  self.motivationPopupView = [MotivationPopupView createMotivationPopupView];
  self.motivationPopupView.delegate = self;
  [self.motivationPopupView prepareMotivationInterfaceBy:motivationPage];
  [UIView transitionWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^ {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.motivationPopupView]; }
                  completion:nil];
}

- (void)dismissMotivationByPage {
  [Helpers dismissCustomView:self.motivationPopupView];
}

#pragma mark - Motivation Delegate

- (void)closeMotivationPopup {
  [self dismissMotivationByPage];
}

- (void)presentMotivationServicesScreen {
  [self dismissMotivationByPage];
  [self presentServicesScreen];
}

#pragma mark - Tutorial

- (void)presentTutorialScreenByType:(TutorialType)tutorialType {
  TutorialViewController *tutorialVC = (TutorialViewController *)[Helpers createCustomVCByStoryboardName:@"Tutorial" andStoryboardId:TUTORIAL_STORYBOARD_ID];
  tutorialVC.tutorialType = tutorialType;
  [self presentViewController:tutorialVC animated:YES completion:nil];
}

@end

#pragma clang diagnostic pop

