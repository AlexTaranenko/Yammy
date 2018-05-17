//
//  HelpViewController.m
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpTableViewCell.h"
#import "ArticleViewController.h"
#import "ChatViewController.h"

@interface HelpViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *items;

@end

@implementation HelpViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  
  [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:kHelpCellIdentifier];
  
  [self prepareBackBarButtonItem];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getHelpTopicsWithCompletion:^(NSArray *topicsArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    self.items = topicsArray;
    [self.tableView reloadData];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HelpTableViewCell *helpCell = [tableView dequeueReusableCellWithIdentifier:kHelpCellIdentifier];
  
  HelpMapping *mapping = [self.items objectAtIndex:indexPath.row];
  [helpCell prepareHelpCellByHelpMapping:mapping];
  
  return helpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  HelpMapping *mapping = [self.items objectAtIndex:indexPath.row];
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Article" andStoryboardId:ARTICLE_STORYBOARD_ID];
  ArticleViewController *articleVC = (ArticleViewController *)[navVC topViewController];
  articleVC.helpMapping = mapping;
  [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendAdminMessageDidTap:(CustomButton *)sender {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getUserAdminSupportWithCompletion:^(NSNumber *userId, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (userId != nil) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] getProfileById:userId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (profileMapping) {
          UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
          ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
          chatVC.profileMapping = profileMapping;
          [self.navigationController pushViewController:chatVC animated:YES];
        } else {
          [UIAlertHelper alert:errorMessage title:nil];
        }
      }];
    } else if (errorMessage != nil) {
      [UIAlertHelper alert:errorMessage title:nil];
    }
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

