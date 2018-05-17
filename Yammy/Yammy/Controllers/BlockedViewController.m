//
//  BlockedViewController.m
//  Yammy
//
//  Created by Alex on 2/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "BlockedViewController.h"
#import "BlockedCollectionViewCell.h"
#import "ProfileViewController.h"

@interface BlockedViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BlockedCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *blockedProfilesArray;

@end

@implementation BlockedViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = self.navTitle;
  
  [self prepareBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadUsersFromServer];
}

- (void)loadUsersFromServer {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getBlockedProfilesWithCompletion:^(NSArray *blockedProfiles, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (blockedProfiles) {
      self.blockedProfilesArray = blockedProfiles;
      [self.collectionView reloadData];
    }
  }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.blockedProfilesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, 60.0);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  BlockedCollectionViewCell *blockedCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kBlockedCollectionCellIdentifier forIndexPath:indexPath];
  blockedCollectionCell.delegate = self;
  ProfileMapping *profileMapping = [self.blockedProfilesArray objectAtIndex:indexPath.row];
  [blockedCollectionCell prepareBlockedCollectionCellByProfileMapping:profileMapping];
  return blockedCollectionCell;
}

- (void)showProfileByCollectionCell:(UICollectionViewCell *)collectionCell {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:collectionCell];
  ProfileMapping *profileMapping = [self.blockedProfilesArray objectAtIndex:indexPath.row];
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = profileMapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)unlockUserByCollectionCell:(UICollectionViewCell *)collectionCell {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:collectionCell];
  ProfileMapping *profileMapping = [self.blockedProfilesArray objectAtIndex:indexPath.row];
  [self presentAlertByMapping:profileMapping];
}

- (void)presentAlertByMapping:(ProfileMapping *)mapping {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
  
  UIView *firstSubview = alertController.view.subviews.firstObject;
  UIView *alertContentView = firstSubview.subviews.firstObject;
  for (UIView *subSubView in alertContentView.subviews) { //This is main catch
    subSubView.backgroundColor = [UIColor whiteColor]; //Here you change background
  }
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Разблокировать пользователя?" attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:16.0]}];
  [alertController setValue:attrString forKey:@"attributedTitle"];
  
  UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] unblockUserByIdUser:mapping.UserId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [Helpers hideSpinner];
      [self loadUsersFromServer];
    }];
  }];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDefault handler:nil];
  
  [yesAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  [cancelAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
  
  [alertController addAction:yesAction];
  [alertController addAction:cancelAction];
  
  [self.navigationController presentViewController:alertController animated:YES completion:nil];
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
