//
//  SettingsViewController.m
//  Yammy
//
//  Created by Alex on 2/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "BlockedViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "AccountViewController.h"
#import "SettingsAccountViewController.h"
#import "ServicesViewController.h"

typedef enum : NSUInteger {
  AccountRow = 0,
  SettingsAccountRow,
  BlockedRow,
  BillingRow,
  HelpRow,
  AboutRow
} SettingsTableViewRows;

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (NSArray *)titlesArray {
  return @[@"Аккаунт", @"Параметры аккаунта", @"Заблокированные", @"Биллинг и платежи", @"Помощь", @"О приложении"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Настройки";
  
  [self prepareBackBarButtonItem];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:kSettingsCellIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self titlesArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SettingsTableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:kSettingsCellIdentifier];
  NSString *titleFromArray = [[self titlesArray] objectAtIndex:indexPath.row];
  settingsCell.titleLabel.text = titleFromArray;
  return settingsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *titleFromArray = [[self titlesArray] objectAtIndex:indexPath.row];
  UIViewController *vc = nil;
  
  switch (indexPath.row) {
    case AccountRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Account" andStoryboardId:ACCOUNT_STORYBOARD_ID];
      AccountViewController *accountVC = (AccountViewController *)[navVC topViewController];
      accountVC.navTitle = titleFromArray;
      vc = accountVC;
    } break;
      
    case SettingsAccountRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"SettingsAccount" andStoryboardId:SETTINGS_ACCOUNT_STORYBOARD_ID];
      SettingsAccountViewController *settingsAccountVC = (SettingsAccountViewController *)[navVC topViewController];
      settingsAccountVC.navTitle = titleFromArray;
      vc = settingsAccountVC;
    } break;
      
    case BlockedRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Blocked" andStoryboardId:BLOCKED_STORYBOARD_ID];
      BlockedViewController *blockedVC = (BlockedViewController *)[navVC topViewController];
      blockedVC.navTitle = titleFromArray;
      vc = blockedVC;
    } break;
      
    case BillingRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Services" andStoryboardId:SERVICES_STORYBOARD_ID];
      ServicesViewController *servicesVC = (ServicesViewController *)[navVC topViewController];
      [self.navigationController pushViewController:servicesVC animated:YES];
    } break;
      
    case HelpRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Help" andStoryboardId:HELP_STORYBOARD_ID];
      HelpViewController *helpVC = (HelpViewController *)[navVC topViewController];
      helpVC.navTitle = titleFromArray;
      vc = helpVC;
    } break;
      
    case AboutRow: {
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"About" andStoryboardId:ABOUT_STORYBOARD_ID];
      AboutViewController *aboutVC = (AboutViewController *)[navVC topViewController];
      aboutVC.navTitle = titleFromArray;
      vc = aboutVC;
    } break;
      
    default:
      break;
  }
  
  if (vc != nil) {
    [self.navigationController pushViewController:vc animated:YES];
  }
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
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

