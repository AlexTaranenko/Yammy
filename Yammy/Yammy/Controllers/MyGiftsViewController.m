//
//  GiftsViewController.m
//  Yammy
//
//  Created by Alex on 10/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyGiftsViewController.h"
#import "PublicProfileGiftsTableViewCell.h"
#import "GiftsViewController.h"
#import "ProfileViewController.h"

@interface MyGiftsViewController ()<UITableViewDelegate, UITableViewDataSource, PublicProfileGiftsTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *giftsArray;

@end

@implementation MyGiftsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Подарки";
  
  [self prepareBackBarButtonItem];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getMyGiftsWithParams:@{@"Token" : [Helpers getAccessToken]} withCompletion:^(NSArray *giftsArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (giftsArray) {
      self.giftsArray = giftsArray;
      [self.tableView reloadData];
    }
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.giftsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PublicProfileGiftsTableViewCell *publicProfileGiftsCell = [tableView dequeueReusableCellWithIdentifier:kPublicProfileGiftsCellIdentifier];
  publicProfileGiftsCell.delegate = self;
  MyGiftMapping *mapping = [self.giftsArray objectAtIndex:indexPath.row];
  [publicProfileGiftsCell preparePublicProfileGiftsCell:mapping];
  return publicProfileGiftsCell;
}

- (void)presentGiftsWithProfile:(ProfileMapping *)profileMapping {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.profileMapping = profileMapping;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)presentProfileByMapping:(ProfileMapping *)mapping {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = mapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)backButtonDidTap:(UIButton *)sender {
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

