//
//  ViewController.m
//  Yammy
//
//  Created by Alex on 12.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeCollectionViewCell.h"
#import "ProfileViewController.h"
#import "HomeCoincidenceHeaderCollectionReusableView.h"
#import "HomeYammyMaxHeaderCollectionReusableView.h"
#import "SearchViewController.h"
#import "SearchModel.h"
#import "SearchPrivateModel.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "PrivateProfileViewController.h"
#import "ChatViewController.h"
#import "HomeMotivationCollectionReusableView.h"
#import "UIViewController+Carousel.h"
#import "HomeYaMaxHeaderCollectionReusableView.h"

static CGFloat const kTotalMargins = 20.0f;
static NSInteger const kNumColumnsPortrait = 3;

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, SearchViewControllerDelegate, HomeCollectionViewCellDelegate, HomeCoincidenceHeaderCollectionReusableViewDelegate, HomeMotivationCollectionReusableViewDelegate, HomeYaMaxHeaderCollectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) SearchModel *searchModel;
@property (strong, nonatomic) SearchPrivateModel *searchPrivateModel;

@property (nonatomic, strong) JCCollectionViewWaterfallLayout *layout;

@property (strong, nonatomic) NSArray *peoplesArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Люди";
  
  self.searchModel = [[SearchModel alloc] init];
  self.searchPrivateModel = [[SearchPrivateModel alloc] init];
  
  [self setupCascadeLayout];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if ([Helpers isShowPeoplesTutorial] == NO) {
      [self presentTutorialScreenByType:PeoplesTutorialType];
    }
  });
  
  [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCoincidenceHeaderCollectionReusableViewOne" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeCoincidenceHeaderViewOne"];
  
  [self.collectionView registerNib:[UINib nibWithNibName:@"HomeMotivationCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeMotivationReusableViewIdentifier];
  
  [self.collectionView registerNib:[UINib nibWithNibName:@"HomeYaMaxHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeYaMaxHeaderReusableViewIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  
  [self loadDataFromServer];
  
  if (![self tabBarIsVisible]) {
    __weak typeof(self) weakSelf = self;
    [self setTabBarVisible:![self tabBarIsVisible] animated:YES completion:^(BOOL finished) {
      [weakSelf.tabBarController.tabBar setHidden:NO];
    }];
  }
  
  [[NSNotificationCenter defaultCenter] addObserverForName:kRealReachabilityChangedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self loadDataFromServer];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
}

#pragma mark - Private

- (void)loadDataFromServer {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    if (self.peoplesArray.count == 0) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] searchDefaultWithCompletion:^(NSArray *peoplesArray, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (peoplesArray) {
          [self setupProfilesArrayByArray:peoplesArray];
        }
      }];
    }
  }
}
- (void)setupProfilesArrayByArray:(NSArray *)array {
  
  for (PeoplesMapping * peoplesMapping in array) {
    NSMutableArray *mutArray = [NSMutableArray new];
    for (ProfileMapping *mapping in peoplesMapping.Profiles) {
      NSInteger index = [peoplesMapping.Profiles indexOfObject:mapping];
      [mutArray addObject:mapping];
      if (index + 1 == 1) {
        [mutArray addObject:[ProfileMapping new]];
      }
    }
    peoplesMapping.Profiles = mutArray;
  }
  
  self.peoplesArray = array;
  [self.collectionView reloadData];
}

- (void)setupCascadeLayout {
  self.layout = (JCCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
}

- (CGFloat)maximumWidthSizeForCell {
  return [UIScreen mainScreen].bounds.size.width / kNumColumnsPortrait - kTotalMargins;
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
  return kNumColumnsPortrait;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:section];
  if (peoplesMapping.Match != nil) {
    return 271;
  } else if (peoplesMapping.Ad != nil) {
    if ([peoplesMapping.Ad.Type integerValue] == MotivationFillYourPublicProfile || [peoplesMapping.Ad.Type integerValue] == MotivationUploadYourPhoto) {
      return 254;
    } else if ([peoplesMapping.Ad.Type integerValue] == MotivationBuyYaMax) {
      return 110;
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
  return 0.0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.peoplesArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:section];
  return peoplesMapping.Profiles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:indexPath.section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:indexPath.row];
  
  if (profileMapping.UserId == nil) {
    UICollectionViewCell *hiddenCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hiddenCollectionCell" forIndexPath:indexPath];
    return hiddenCollectionCell;
  } else {
    HomeCollectionViewCell *homeCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCollectionCell" forIndexPath:indexPath];
    homeCollectionCell.delegate = self;
    
    if ([profileMapping.CircleSize integerValue] == SmallCircleType) {
      [homeCollectionCell updatePhotoImageConstraintsByValue:[self maximumWidthSizeForCell] - 20];
    } else {
      [homeCollectionCell updatePhotoImageConstraintsByValue:[self maximumWidthSizeForCell] - 10];
    }

    if (![profileMapping.HasPrivateProfile boolValue]) {
      [homeCollectionCell hideStrawberryIconImageView:YES];
    } else {
      if ([profileMapping.HasPrivateProfilePrivateInteresets boolValue] && [profileMapping.HasPrivateProfileGeneralInfo boolValue]) {
        if ([profileMapping.HasPrivateProfilePrivatePreferences boolValue]) {
          [homeCollectionCell hideStrawberryIconImageView:NO];
          [homeCollectionCell prepareBorderPhotoImageView];
          [homeCollectionCell setupPulseAnimation];
        } else {
          [homeCollectionCell hideStrawberryIconImageView:YES];
          [homeCollectionCell prepareBorderPhotoImageView];
          [homeCollectionCell setupPulseAnimation];
        }
      } else {
        [homeCollectionCell hideStrawberryIconImageView:YES];
        [homeCollectionCell prepareBorderPhotoImageView];
      }
    }
    
    [homeCollectionCell layoutIfNeeded];
    [homeCollectionCell prepareCellByMapping:profileMapping];

    return homeCollectionCell;
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:indexPath.section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:indexPath.row];
  if (profileMapping.UserId != nil) {
    UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
    ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
    profileVC.profileMapping = profileMapping;
    profileVC.isShowProfile = YES;
    [self.navigationController pushViewController:profileVC animated:YES];
  }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  
  UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:indexPath.section];
  if (peoplesMapping.Match != nil) {
    HomeCoincidenceHeaderCollectionReusableView *homeCoincidenceHeaderCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"homeCoincidenceHeaderViewOne" forIndexPath:indexPath];
    homeCoincidenceHeaderCollectionReusableView.delegate = self;
    [homeCoincidenceHeaderCollectionReusableView prepareHomeCoincidenceByMatchMapping:peoplesMapping.Match];
    return homeCoincidenceHeaderCollectionReusableView;
  } else if (peoplesMapping.Ad != nil) {
    if ([peoplesMapping.Ad.Type integerValue] == MotivationFillYourPublicProfile ||
        [peoplesMapping.Ad.Type integerValue] == MotivationUploadYourPhoto) {
      HomeMotivationCollectionReusableView *homeMotivationCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeMotivationReusableViewIdentifier forIndexPath:indexPath];
      homeMotivationCollectionReusableView.delegate = self;
      [homeMotivationCollectionReusableView prepareHomeMotivationByType:[peoplesMapping.Ad.Type integerValue]];
      return homeMotivationCollectionReusableView;
    } else if ([peoplesMapping.Ad.Type integerValue] == MotivationBuyYaMax) {
      HomeYaMaxHeaderCollectionReusableView *homeYaMaxHeaderCollectionReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHomeYaMaxHeaderReusableViewIdentifier forIndexPath:indexPath];
  homeYaMaxHeaderCollectionReusableView.delegate = self;
      return homeYaMaxHeaderCollectionReusableView;
    } else {
      return reusableView;
    }
  } else {
    return reusableView;
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:indexPath.section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:indexPath.row];
  
  CGFloat height = 0;
  CGFloat width = 0;
  if (profileMapping.UserId == nil) {
    height = [UIScreen mainScreen].bounds.size.width / (kNumColumnsPortrait * 3);
    width = [UIScreen mainScreen].bounds.size.width / kNumColumnsPortrait;
    return CGSizeMake(width, height);
  } else {
    height = [UIScreen mainScreen].bounds.size.width / kNumColumnsPortrait;
    width = height;
    return CGSizeMake(width, height);
  }
}

#pragma mark Delegate

- (void)getSearchGeneralWithParams:(NSDictionary *)params {
  [Helpers showSpinner];
  [[ServerManager sharedManager] searchGeneralWithParams:params withCompletion:^(NSArray *profilesArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (profilesArray) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self setupProfilesArrayByArray:profilesArray];
      });
    }
  }];
}

- (void)privateSearchByParams:(NSDictionary *)params {
  [Helpers showSpinner];
  [[ServerManager sharedManager] searchPreferencesWithParams:params withCompletion:^(NSArray *profilesArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (profilesArray) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [self setupProfilesArrayByArray:profilesArray];
      });
    }
  }];
}

- (void)presentProfileScreenByCell:(UICollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:indexPath.section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:indexPath.row];
  if (profileMapping.UserId != nil) {
    [self presentPrivateProfileByMapping:profileMapping];
  }
}

- (void)showChatByView:(UICollectionReusableView *)view {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:[self indexPathFromView:view].section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:[self indexPathFromView:view].row];
  if (profileMapping.UserId != nil) {
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
    ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
    chatVC.profileMapping = profileMapping;
    [self.navigationController pushViewController:chatVC animated:YES];
  }
}

- (void)showPrivateProfileByView:(UICollectionReusableView *)view {
  PeoplesMapping *peoplesMapping = [self.peoplesArray objectAtIndex:[self indexPathFromView:view].section];
  ProfileMapping *profileMapping = [peoplesMapping.Profiles objectAtIndex:[self indexPathFromView:view].row];
  if (profileMapping.UserId != nil) {
    [self presentPrivateProfileByMapping:profileMapping];
  }
}

- (NSIndexPath *)indexPathFromView:(UICollectionReusableView *)view {
  CGPoint center = view.center;
  CGPoint rootViewPoint = [view.superview convertPoint:center toView:self.collectionView];
  NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:rootViewPoint];
  return indexPath;
}

- (void)selectPhotoFromGallery {
  [self presentPhotoGallery];
}

- (void)openCamera {
  [self presentCameraPhoto];
}

- (void)showMyProfile {
  [(TabBarViewController *)DELEGATE.window.rootViewController setSelectedIndex:MyProfileTabBarIndex];
}

- (void)openServicesScreen {
  [self presentServicesScreen];
}

#pragma mark Actions

- (IBAction)searchDidTap:(UIButton *)sender {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Search" andStoryboardId:SEARCH_STORYBOARD_ID];
  SearchViewController *searchVC = (SearchViewController *)[navVC topViewController];
  searchVC.delegate = self;
  searchVC.searchModel = [self.searchModel savedSearchModel];
  [self.navigationController pushViewController:searchVC animated:YES];
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

