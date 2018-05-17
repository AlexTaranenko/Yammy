//
//  SplashViewController.m
//  Yammy
//
//  Created by Alex on 29.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SplashViewController.h"
#import "LocationManager.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [[LocationManager sharedManager] setupLocation];
    
  if ([Helpers getAccessToken].length == 0) {
    [DELEGATE setupLoginController];
  } else {
    if ([ServerManager sharedManager].myProfileMapping == nil && DELEGATE.isDidTapNotification == NO) {
      [[ServerManager sharedManager] getProfileById:nil withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
        if (profileMapping) {
          [ServerManager sharedManager].myProfileMapping = profileMapping;
        }
      }];
    }
    [DELEGATE setupTabBarControllerWithSelectIndex:ActivityLineTabBarIndex];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

