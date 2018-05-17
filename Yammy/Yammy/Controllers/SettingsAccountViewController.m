//
//  SettingsAccountViewController.m
//  Yammy
//
//  Created by Alex on 2/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "SettingsAccountViewController.h"
#import "SettingsTableViewCell.h"
#import "DetailSettingsAccountViewController.h"
#import "UserSettingsMapping.h"

typedef enum : NSUInteger {
  ConfidenceRow = 0,
  NotificationRow,
  LanguageRow,
  VerificationRow,
  DeleteProfileRow
} SettingsAccountRow;

@interface SettingsAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UserSettingsMapping *userSettingsMapping;

@end

@implementation SettingsAccountViewController

- (NSArray *)titlesArray {
  return @[@"Конфиденциальность", @"Уведомления", @"Языковые настройки", @"Верификация", @"Удаление профиля"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  [self prepareBackBarButtonItem];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:kSettingsCellIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[ServerManager sharedManager] getUserSettingsWithCompletion:^(UserSettingsMapping *userSettingsMapping, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.userSettingsMapping = userSettingsMapping;
    });
  }];
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
  
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"DetailSettingsAccount" andStoryboardId:DETAIL_SET_ACOUNT_STORYBOARD_ID];
  DetailSettingsAccountViewController *detailSettingsAccountVC = (DetailSettingsAccountViewController *)[navVC topViewController];
  NSString *titleFromArray = [[self titlesArray] objectAtIndex:indexPath.row];
  detailSettingsAccountVC.navTitle = titleFromArray;
  detailSettingsAccountVC.userSettingsMapping = self.userSettingsMapping;
  
  switch (indexPath.row) {
    case ConfidenceRow:
      detailSettingsAccountVC.detailSettingsAccountRow = ConfidenceRow; break;
      
    case NotificationRow:
      detailSettingsAccountVC.detailSettingsAccountRow = NotificationRow; break;
      
    case LanguageRow:
      detailSettingsAccountVC.detailSettingsAccountRow = LanguageRow; break;
      
    case VerificationRow:
      detailSettingsAccountVC.detailSettingsAccountRow = VerificationRow; break;
      
    case DeleteProfileRow:
      detailSettingsAccountVC.detailSettingsAccountRow = DeleteProfileRow; break;
  }
  
  [self.navigationController pushViewController:detailSettingsAccountVC animated:YES];
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

