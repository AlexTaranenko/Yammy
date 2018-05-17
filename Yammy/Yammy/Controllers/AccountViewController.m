//
//  AccountViewController.m
//  Yammy
//
//  Created by Alex on 2/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "AccountViewController.h"
#import "NewRegisterViewController.h"
#import "DirectConnectionClient.h"

@interface AccountViewController ()

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@end

@implementation AccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  
  self.emailLabel.text = [ServerManager sharedManager].myProfileMapping.Email;
  
  self.passwordLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Забыли пароль?" attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentRecovery:)];
  tapGesture.numberOfTapsRequired = 1;
  [self.passwordLabel addGestureRecognizer:tapGesture];
  
  self.passwordLabel.userInteractionEnabled = YES;
  
  [self prepareBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)presentRecovery:(UIGestureRecognizer *)sender {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"NewRegister" andStoryboardId:NEW_REGISTER_STORYBOARD_ID];
  NewRegisterViewController *newRegisterVC = (NewRegisterViewController *)[navVC topViewController];
  newRegisterVC.isFromMyAccount = YES;
  newRegisterVC.loginModel = [[LoginModel alloc] init];
  [self.navigationController pushViewController:newRegisterVC animated:YES];
}

- (IBAction)logoutDidTap:(CustomButton *)sender {
  [[ServerManager sharedManager] signOutByIsEveryWhere:NO withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    [Helpers resetValues];
  }];
}

- (IBAction)logoutAllDevices:(CustomButton *)sender {
  [[ServerManager sharedManager] signOutByIsEveryWhere:YES withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    [Helpers resetValues];
  }];
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

