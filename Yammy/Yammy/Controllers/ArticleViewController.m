//
//  ArticleViewController.m
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ArticleViewController.h"
#import "HelpTableViewCell.h"
#import "ArticleModel.h"

@interface ArticleViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *articlesArray;

@end

@implementation ArticleViewController

- (NSMutableArray *)articlesArray {
  if (_articlesArray == nil) {
    _articlesArray = [NSMutableArray new];
  }
  return _articlesArray;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.helpMapping.Title;
  
  [self prepareBackBarButtonItem];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:kHelpCellIdentifier];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getHelpArticlesByIdTopic:self.helpMapping.IdHelp withCompletion:^(NSArray *articlesArray, NSString *errorMessage) {
    
    for (ArticleMapping *mapping in articlesArray) {
      ArticleModel *model = [[ArticleModel alloc] initWithArticleMapping:mapping];
      [self.articlesArray addObject:model];
    }
    
    [Helpers hideSpinner];
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
  return self.articlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HelpTableViewCell *helpCell = [tableView dequeueReusableCellWithIdentifier:kHelpCellIdentifier];
  
  ArticleModel *articleModel = [self.articlesArray objectAtIndex:indexPath.row];
  [helpCell prepareHelpCellByArticleModel:articleModel];
  
  return helpCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ArticleModel *articleModel = [self.articlesArray objectAtIndex:indexPath.row];
  articleModel.isShowContent = articleModel.isShowContent ? NO : YES;
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

