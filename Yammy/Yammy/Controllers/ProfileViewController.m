//
//  ProfileViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileContainerViewController.h"
#import "StrawberryNavView.h"
#import "SettingsButtonView.h"
#import "SettingsViewController.h"

@interface ProfileViewController ()<StrawberryNavViewDelegate, SettingsButtonViewDelegate, ProfileContainerViewControllerDelegate>

@property (strong, nonatomic) ProfileContainerViewController *profileContainerViewController;

@end

@implementation ProfileViewController
{
  BOOL _isShowingPrivateProfile;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isShowProfile) {
    self.navigationItem.title = self.profileMapping.FirstName;
    [self prepareBackBarButtonItem];
  } else {
    self.navigationItem.title = @"Мой профиль";
    if ([Helpers isShowMyPublicProfileTutorial] == NO) {
      [self presentTutorialScreenByType:MyPublicTutorialType];
    }
    [self setupSettingsButtonView];
  }
  
  //  [self prepareCancelBarButtonItem];
  [self setupRightSliderNavView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (_isShowingPrivateProfile) {
    [Helpers prepareStatusBarWithColor:[UIColor blackColor]];
    [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:[UIColor blackColor]];
  } else {
    [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
    [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  }
  
  if (![self tabBarIsVisible]) {
    __weak typeof(self) weakSelf = self;
    [self setTabBarVisible:![self tabBarIsVisible] animated:YES completion:^(BOOL finished) {
      [weakSelf.tabBarController.tabBar setHidden:NO];
    }];
  }
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  if (IS_IPHONE_X) {
    if ([[UIScreen mainScreen] bounds].size.height == DELEGATE.window.rootViewController.view.frame.size.height) {
      DELEGATE.window.rootViewController.view.frame = CGRectMake(DELEGATE.window.rootViewController.view.frame.origin.x, DELEGATE.window.rootViewController.view.frame.origin.y, DELEGATE.window.rootViewController.view.frame.size.width, DELEGATE.window.rootViewController.view.frame.size.height + 32) ;
    }
  }
}

#pragma mark - Slider

- (void)setupRightSliderNavView {
  self.navigationItem.rightBarButtonItem = nil;
  StrawberryNavView *strawberryNavView = [StrawberryNavView setupStrawberryNavView];
  strawberryNavView.delegate = self;
  [self prepareLayoutByView:strawberryNavView];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:strawberryNavView];
}

- (void)setupSettingsButtonView {
  self.navigationItem.leftBarButtonItem = nil;
  SettingsButtonView *settingsButtonView = [SettingsButtonView setupSettingsButtonView];
  settingsButtonView.delegate = self;
  
  [self prepareLayoutByView:settingsButtonView];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButtonView];
}

- (void)prepareLayoutByView:(UIView *)view {
  NSLayoutConstraint * widthConstraint = [view.widthAnchor constraintEqualToConstant:30];
  NSLayoutConstraint * HeightConstraint = [view.heightAnchor constraintEqualToConstant:30];
  [widthConstraint setActive:YES];
  [HeightConstraint setActive:YES];
}

- (IBAction)onSwipeRight:(id)sender {
  if(_isShowingPrivateProfile)
    [self switchPrivateToPublicVC];
}
- (IBAction)onSwipeLeft:(id)sender {
  if(!_isShowingPrivateProfile)
    [self changePublicToPrivateVC];
}

- (void)changePublicToPrivateVC {
  [Helpers prepareStatusBarWithColor:[UIColor blackColor]];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:[UIColor blackColor]];
  
  if (self.isShowProfile) {
    self.navigationItem.title = self.profileMapping.FirstName;
    [self.profileContainerViewController segueIdentifierReceivedFromParent:PROFILE_PRIVATE_CONTAINER_SEGUE];
  } else {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"Приватный профиль";
    if ([Helpers isShowMyPrivateProfileTutorial] == NO) {
      [self presentTutorialScreenByType:MyPrivateTutorialType];
    }
    [self.profileContainerViewController segueIdentifierReceivedFromParent:MY_PROFILE_PRIVATE_CONTAINER_SEGUE];
  }
  
  [self prepareRightCancelBarButtonItem];
  _isShowingPrivateProfile = YES;
}

- (void) switchPrivateToPublicVC {
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  
  if (self.isShowProfile) {
    self.navigationItem.title = self.profileMapping.FirstName;
    [self.profileContainerViewController segueIdentifierReceivedFromParent:PROFILE_PUBLIC_CONTAINER_SEGUE];
  } else {
    [self setupSettingsButtonView];
    self.navigationItem.title = @"Мой профиль";
    if ([Helpers isShowMyPublicProfileTutorial] == NO) {
      [self presentTutorialScreenByType:MyPublicTutorialType];
    }
    [self.profileContainerViewController segueIdentifierReceivedFromParent:MY_PROFILE_PUBLIC_CONTAINER_SEGUE];
  }
  //  [self.profileContainerViewController segueIdentifierReceivedFromParent:PROFILE_PUBLIC_CONTAINER_SEGUE];
  //  [self.profileContainerViewController segueIdentifierReceivedFromParent:MY_PROFILE_PUBLIC_CONTAINER_SEGUE];
  [self setupRightSliderNavView];
  _isShowingPrivateProfile = NO;
}

- (void)rightBackButtonDidTap:(id)sender {
  [self switchPrivateToPublicVC];
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSettingsController {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Settings" andStoryboardId:SETTINGS_STORYBOARD_ID];
  SettingsViewController *settingsVC = (SettingsViewController *)[navVC topViewController];
  [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)presentOtherPrivateProfile {
  if(!_isShowingPrivateProfile)
    [self changePublicToPrivateVC];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:PROFILE_CONTAINER_SEGUE]) {
    self.profileContainerViewController = (ProfileContainerViewController *)[segue destinationViewController];
    self.profileContainerViewController.delegate = self;
    self.profileContainerViewController.profileMapping = self.profileMapping;
    self.profileContainerViewController.isShowProfile = self.isShowProfile;
  }
}


@end

