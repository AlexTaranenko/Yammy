//
//  ProfileContainerViewController.m
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ProfileContainerViewController.h"
#import "PublicProfileViewController.h"
#import "PrivateProfileViewController.h"
#import "MyPublicProfileViewController.h"

@interface ProfileContainerViewController ()<PublicProfileViewControllerDelegate>

@property (strong, nonatomic) NSString *segueIdentifier;

@end

@implementation ProfileContainerViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isShowProfile) {
    [self segueIdentifierReceivedFromParent:PROFILE_PUBLIC_CONTAINER_SEGUE];
  } else {
    [self segueIdentifierReceivedFromParent:MY_PROFILE_PUBLIC_CONTAINER_SEGUE];
  }
  //  [self segueIdentifierReceivedFromParent:PROFILE_PUBLIC_CONTAINER_SEGUE];
  //  [self segueIdentifierReceivedFromParent:MY_PROFILE_PUBLIC_CONTAINER_SEGUE];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:UPDATE_PROFILE_MAPPING object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    self.profileMapping = (ProfileMapping *)note.object;
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_PROFILE_MAPPING object:nil];
}

- (void)segueIdentifierReceivedFromParent:(NSString*)segueIdentifier {
  self.segueIdentifier = segueIdentifier;
  [self performSegueWithIdentifier:self.segueIdentifier sender:nil];
}

- (void)presentPrivateProfileVC {
  if (self.delegate != nil) {
    [self.delegate presentOtherPrivateProfile];
  }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  UIViewController  *lastViewController, *vc;
  if ([segue.identifier isEqualToString:self.segueIdentifier]) {
    if(lastViewController != nil) {
      [lastViewController.view removeFromSuperview];
    }
    
    if ([segue.identifier isEqualToString:PROFILE_PUBLIC_CONTAINER_SEGUE]) {
      PublicProfileViewController *publicProfileViewController = (PublicProfileViewController *)[segue destinationViewController];
      publicProfileViewController.profileMapping = self.profileMapping;
      publicProfileViewController.delegate = self;
      vc = publicProfileViewController;
    } else {
      
      UIViewController *customVC = (UIViewController *)[segue destinationViewController];
      if ([customVC isKindOfClass:[MyPublicProfileViewController class]]) {
        MyPublicProfileViewController *myPublicProfileViewController = (MyPublicProfileViewController *)customVC;
        vc = myPublicProfileViewController;
      } else if ([customVC isKindOfClass:[PrivateProfileViewController class]]) {
        PrivateProfileViewController *privateProfileVC = (PrivateProfileViewController *)customVC;
        privateProfileVC.profileMapping = self.profileMapping;
        vc = privateProfileVC;
      } else {
        vc = customVC;
      }
    }
    
    [self addChildViewController:(vc)];
    
    vc. view.frame  = CGRectMake(0,0, self.view.frame.size.width , self.view.frame.size.height);
    
    [self.view addSubview:vc.view];
    lastViewController = vc;
  }
}

@end

