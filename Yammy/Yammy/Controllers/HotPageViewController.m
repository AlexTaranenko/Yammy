//
//  HotPageViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HotPageViewController.h"
#import "HotPageCollectionViewCell.h"
#import "ProfileViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "ProfileMapping.h"
#import "ChatViewController.h"
#import "GiftsViewController.h"
#import "YSLDraggableCardContainer.h"
#import "HotPageCardView.h"
#import "TutorialViewController.h"
#import "MotivationProfilePopupView.h"
#import "UIViewController+Carousel.h"
#import "MotivationVerifyModeratorPopupView.h"
#import "MotivationYaStarView.h"
#import "MotivationInvisiblePopupView.h"
#import "MotivationTranslatorPopupView.h"
#import "MotivationMatchProfilePopupView.h"
#import "MotivationPrivateProfilePopupView.h"
#import "RequestShowPrivateProfileView.h"

@interface HotPageViewController ()<GiftsViewControllerDelegate, YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource, HotPageCardViewDelegate, MotivationProfilePopupViewDelegate, MotivationVerifyModeratorPopupViewDelegate, MotivationYaStarViewDelegate, MotivationInvisiblePopupViewDelegate, MotivationTranslatorPopupViewDelegate, MotivationPrivateProfilePopupViewDelegate, MotivationMatchProfilePopupViewDelegate, RequestShowPrivateProfileViewDelegate, VerificationPhotoViewDelegate>

@property (weak, nonatomic) IBOutlet YSLDraggableCardContainer *container;

@property (strong, nonatomic) ProfileMapping *profileMapping;

@property (strong, nonatomic) NSMutableArray *profilesArray;

@property (strong, nonatomic) MotivationProfilePopupView *motivationProfilePopupView;

@property (strong, nonatomic) PeoplesMapping *peoplesMapping;

@property (strong, nonatomic) MotivationVerifyModeratorPopupView *motivationVerifyModeratorPopupView;

@property (strong, nonatomic) MotivationYaStarView *motivationYaStarView;

@property (strong, nonatomic) MotivationInvisiblePopupView *motivationInvisiblePopupView;

@property (strong, nonatomic) MotivationTranslatorPopupView *motivationTranslatorPopupView;

@property (strong, nonatomic) MotivationMatchProfilePopupView *motivationMatchProfilePopupView;

@property (strong, nonatomic) MotivationPrivateProfilePopupView *motivationPrivateProfilePopupView;

@property (strong, nonatomic) RequestShowPrivateProfileView *requestShowPrivateProfileView;

@property (strong, nonatomic) NSNumber *level;

@end

@implementation HotPageViewController

- (NSMutableArray *)profilesArray {
  if (_profilesArray == nil) {
    _profilesArray = [NSMutableArray new];
  }
  return _profilesArray;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Лица";
  
  if ([Helpers isShowHotPageTutorial] == NO) {
    [self presentTutorialScreenByType:HotPageTutorialType];
  }
  
  self.container.delegate = self;
  self.container.dataSource = self;
  self.container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight;
  
  [self loadHotPageListFromServer];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:kRealReachabilityChangedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self loadHotPageListFromServer];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
}

#pragma mark - Private

- (void)loadHotPageListFromServer {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    [[ServerManager sharedManager] getHotPageListWithCompletion:^(PeoplesMapping *peoplesMapping, NSString *errorMessage) {
      if (peoplesMapping) {
        self.peoplesMapping = peoplesMapping;
        [self.profilesArray addObjectsFromArray:peoplesMapping.Profiles];
        self.profileMapping = (ProfileMapping *)[self.profilesArray firstObject];
        [self.container reloadCardContainer];
      }
    }];
  }
}

- (void)sendLikeToUserByIsNextUser:(BOOL)isNext {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    if ([self.profileMapping.IsLikedByMe boolValue] == NO) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(0)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
        [Helpers hideSpinner];
        
        [Helpers hideSpinner];
        if (matchMapping != nil) {
          if (statusCode != nil && [statusCode isEqualToNumber:@(517)]) {
            [UIAlertHelper alert:errorMessage title:nil];
          } else if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
            [self presentMotivationByPage:LikePage];
          } else {
            [self showMotivationMatchProfilePopupViewByMatchMapping:matchMapping];
          }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:isNext];
          
          [self updateCardView];
        });
      }];
    } else {
      [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:isNext];
    }
  }
}

- (void)showMotivationProfilePopupByAdType:(AdTypes)adTypes {
  if (adTypes == MotivationFillYourPublicProfile) {
    self.motivationProfilePopupView = [MotivationProfilePopupView createMotivationProfilePopupView:kMotivationProfilePopupView];
  } else if (adTypes == MotivationUploadYourPhoto) {
    self.motivationProfilePopupView = [MotivationProfilePopupView createMotivationProfilePopupView:kMotivationProfileUploadPhotoPopupView];
  }
  
  self.motivationProfilePopupView.delegate = self;
  [Helpers showCustomView:self.motivationProfilePopupView];
}

- (void)showMotivationVerifyModeratorPopupViewAdType:(AdTypes)adTypes {
  self.motivationVerifyModeratorPopupView = [MotivationVerifyModeratorPopupView createMotivationVerifyModeratorPopupViewByAdType:adTypes];
  self.motivationVerifyModeratorPopupView.delegate = self;
  [Helpers showCustomView:self.motivationVerifyModeratorPopupView];
}

- (void)showMotivationYaStarView {
  self.motivationYaStarView = [MotivationYaStarView createMotivationYaStarView];
  self.motivationYaStarView.delegate = self;
  [Helpers showCustomView:self.motivationYaStarView];
}

- (void)showMotivationInvisiblePopupView {
  self.motivationInvisiblePopupView = [MotivationInvisiblePopupView createMotivationInvisiblePopupView];
  self.motivationInvisiblePopupView.delegate = self;
  [Helpers showCustomView:self.motivationInvisiblePopupView];
}

- (void)showMotivationTranslatorPopupView {
  self.motivationTranslatorPopupView = [MotivationTranslatorPopupView createMotivationTranslatorPopupView];
  self.motivationTranslatorPopupView.delegate = self;
  [Helpers showCustomView:self.motivationTranslatorPopupView];
}

- (void)showMotivationMatchProfilePopupViewByMatchMapping:(MatchMapping *)matchMapping {
  self.motivationMatchProfilePopupView = [MotivationMatchProfilePopupView createMotivationPrivateProfilePopupView];
  self.motivationMatchProfilePopupView.delegate = self;
  [self.motivationMatchProfilePopupView prepareInterfaceByMatchMapping:matchMapping];
  [Helpers showCustomView:self.motivationMatchProfilePopupView];
}

- (void)showMotivationPrivateProfilePopupView {
  self.motivationPrivateProfilePopupView = [MotivationPrivateProfilePopupView createMotivationPrivateProfilePopupView];
  self.motivationPrivateProfilePopupView.delegate = self;
  [Helpers showCustomView:self.motivationPrivateProfilePopupView];
}

- (void)showRequestShowPrivateProfileView {
  self.requestShowPrivateProfileView = [RequestShowPrivateProfileView createRequestShowPrivateProfileView];
  self.requestShowPrivateProfileView.delegate = self;
  [self.requestShowPrivateProfileView prepareInterfaceByProfileMapping:self.profileMapping];
  [Helpers showCustomView:self.requestShowPrivateProfileView];
}

#pragma mark - Container

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index {
  HotPageCardView *hotPageCardView = [HotPageCardView setupHotPageCardViewWithFrame:CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height)];
  hotPageCardView.delegate = self;
  ProfileMapping *profileMapping = [self.profilesArray objectAtIndex:index];
  [hotPageCardView prepareHotPageInterfaceByProfileMapping:profileMapping];
  return hotPageCardView;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index {
  return self.profilesArray.count;
}

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView
    didEndDraggingAtIndex:(NSInteger)index
            draggableView:(UIView *)draggableView
       draggableDirection:(YSLDraggableDirection)draggableDirection {
  
  if (draggableDirection == YSLDraggableDirectionLeft) {
    [cardContainerView movePositionWithDirection:draggableDirection isAutomatic:NO];
  } else if (draggableDirection == YSLDraggableDirectionRight) {
    [self sendLikeToUserByIsNextUser:NO];
  }
  
  [self updateCardView];
}

- (void)showAdMotivation {
  if (self.peoplesMapping.Ad != nil) {
    switch ([self.peoplesMapping.Ad.Type integerValue]) {
      case MotivationFillYourPublicProfile:
        [self showMotivationProfilePopupByAdType:MotivationFillYourPublicProfile];
        break;
        
      case MotivationUploadYourPhoto:
        [self showMotivationProfilePopupByAdType:MotivationUploadYourPhoto];
        break;
        
      case MotivationVerifyYourAccount:
        [self showMotivationVerifyModeratorPopupViewAdType:MotivationVerifyYourAccount];
        break;
        
      case MotivationBecomeModerator:
        [self showMotivationVerifyModeratorPopupViewAdType:MotivationBecomeModerator];
        break;
        
      case MotivationBuyYaStar:
        [self showMotivationYaStarView];
        break;
        
      case MotivationBuyInvisibility:
        [self showMotivationInvisiblePopupView];
        break;
        
      case  MotivationBuyTranslator:
        [self showMotivationTranslatorPopupView];
        break;
        
      case MotivationFillYourPrivateProfile:
        [self showMotivationPrivateProfilePopupView];
        break;
        
      default:
        break;
    }
  }
}

- (void)cardContainderView:(YSLDraggableCardContainer *)cardContainderView updatePositionWithDraggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio {
  
  HotPageCardView *hotPageCardView = (HotPageCardView *)draggableView;
  CGFloat alpha = widthRatio * 1.5 > 1.0 ? 1.0 : widthRatio * 1.5;
  
  if (draggableDirection == YSLDraggableDirectionDefault) {
    [hotPageCardView prepareIconImageViewByImageName:nil andAlpha:0.0];
    [hotPageCardView updateIconImageViewFrameByValue:0.0];
    [hotPageCardView layoutIfNeeded];
  }
  
  if (draggableDirection == YSLDraggableDirectionRight) {
    [hotPageCardView prepareIconImageViewByImageName:@"hearth_card_icon" andAlpha:alpha];
    [hotPageCardView updateIconImageViewFrameByValue:alpha > 0.6 ? alpha : 0.0];
    [hotPageCardView layoutIfNeeded];
  }
  
  if (draggableDirection == YSLDraggableDirectionLeft) {
    [hotPageCardView prepareIconImageViewByImageName:@"close_card_icon" andAlpha:alpha];
    [hotPageCardView updateIconImageViewFrameByValue:alpha > 0.6 ? alpha : 0.0];
    [hotPageCardView layoutIfNeeded];
  }
  
}

#pragma mark - Delegate

- (void)presentProfileVC {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = self.profileMapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)presentGiftVC {
  [self presentGiftScreen:NO];
}

- (void)presentGiftScreen:(BOOL)isRequestProfile {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.profileMapping = isRequestProfile == NO ? self.profileMapping : nil;
  giftsVC.delegate = self;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)sendKingLike {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    if ([self.profileMapping.IsSuperLikedByMe boolValue] == NO) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(1)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (matchMapping != nil) {
          if (statusCode != nil && [statusCode isEqualToNumber:@(517)]) {
            [UIAlertHelper alert:errorMessage title:nil];
          } else if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
            [self presentMotivationByPage:KingLikePage];
          } else {
            [self showMotivationMatchProfilePopupViewByMatchMapping:matchMapping];
          }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [self.container movePositionWithDirection:YSLDraggableDirectionRight isAutomatic:YES];
          
          [self updateCardView];
        });
      }];
    }
  }
}

- (void)updateCardView {
  [self.profilesArray removeObjectAtIndex:0];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.container reloadCardContainer];
  });
  
  if (self.profilesArray.count == 0) {
    [self loadHotPageListFromServer];
    [self showAdMotivation];
  } else {
    self.profileMapping = (ProfileMapping *)[self.profilesArray firstObject];
  }
}

- (void)presentChatVC {
  if (self.profileMapping != nil) {
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
    ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
    chatVC.profileMapping = self.profileMapping;
    [self.navigationController pushViewController:chatVC animated:YES];
  }
}

- (void)selectStrawberryByCustomButton:(CustomButton *)sender {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    
//    [self presentPrivateProfileByMapping:self.profileMapping];
    
    CustomButton *strawberryButton = sender;
    NSNumber *levelForHasBlock = [self getNumberOfStrawberryByTag:@(strawberryButton.tag - 10) withArray:[self itemsOfHasProfileBlocks]];
    NSNumber *boolHasBlock = [[self itemsOfHasProfileBlocks] objectAtIndex:[levelForHasBlock integerValue]];

    if ([boolHasBlock boolValue]) {

      NSNumber *levelForRequest = [self getNumberOfStrawberryByTag:@(strawberryButton.tag - 10) withArray:[self itemsOfStrawberry]];
      if (levelForRequest) {
        NSNumber *boolLevel = [[self itemsOfStrawberry] objectAtIndex:[levelForRequest integerValue]];
        if ([boolLevel boolValue]) {
          self.level = levelForRequest;
          [self showRequestShowPrivateProfileView];
        }
      }
    }
  }
}

- (void)presentPhotoBrowser {
  
}

- (void)sendRequestWithParams:(NSDictionary *)params {
  [Helpers showSpinner];
  [[ServerManager sharedManager] requestPrivateProfileWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
    self.level = nil;
    [Helpers hideSpinner];
    if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 531) {
      [self presentMotivationByPage:YaMaxPage];
    } else if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 530) {
      [UIAlertHelper alert:responseStatusModel.localized title:responseStatusModel.errorMessage];
    } else {
      [WToast showWithText:@"Запрос отправлен"];
    }
  }];
}

#pragma mark - Actions

- (IBAction)likeDidTap:(UIButton *)sender {
  //  [self sendLikeToUser];
}

- (NSNumber *)getNumberOfStrawberryByTag:(NSNumber *)tag withArray:(NSArray *)array {
  
  NSNumber *level = nil;
  for (int index = 0; index < array.count; index++) {
    if (index == [tag integerValue]) {
      level = @(index);
      break;
    }
  }
  
  return level;
}

- (NSArray *)itemsOfStrawberry {
  return @[self.profileMapping.IsPrivateProfileHidden,
           self.profileMapping.IsPrivateProfileGeneralInfoHidden,
           self.profileMapping.IsPrivateProfilePrivateInteresetsHidden,
           self.profileMapping.IsPrivateProfilePrivatePreferencesHidden];
}

- (NSArray *)itemsOfHasProfileBlocks {
  return @[self.profileMapping.HasPrivateProfile,
           self.profileMapping.HasPrivateProfileGeneralInfo,
           self.profileMapping.HasPrivateProfilePrivateInteresets,
           self.profileMapping.HasPrivateProfilePrivatePreferences];
}

#pragma mark - Collection Cell Delegate

- (void)selectItemByCell:(UICollectionViewCell *)collectionCell {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = self.profileMapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - Hot Page Delegate

- (void)reloadGiftsAtTheProfile {
  // To Do
}

- (void)sendGiftBySelectGiftMapping:(GiftMapping *)giftMapping {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"UserId" : self.profileMapping.UserId,
                           @"Level" : self.level,
                           @"GiftId" : giftMapping.IdGift};
  [self sendRequestWithParams:params];

}

- (void)closeMotivationProfilePopup {
  [Helpers dismissCustomView:self.motivationProfilePopupView];
}

- (void)openMotivationProfilePopupGallery {
  [Helpers dismissCustomView:self.motivationProfilePopupView];
  [self presentPhotoGallery];
}

- (void)openMotivationProfilePopupCamera {
  [Helpers dismissCustomView:self.motivationProfilePopupView];
  [self presentCameraPhoto];
  
}

- (void)showMotivationProfilePopupMyProfile {
  [Helpers dismissCustomView:self.motivationProfilePopupView];
  [(TabBarViewController *)DELEGATE.window.rootViewController setSelectedIndex:MyProfileTabBarIndex];
}

- (void)closeMotivationVerifyModeratorPopup {
  [Helpers dismissCustomView:self.motivationVerifyModeratorPopupView];
}

- (void)selectCustomButtonByAdTypes:(AdTypes)adTypes {
  [Helpers dismissCustomView:self.motivationVerifyModeratorPopupView];
  
  if (adTypes == MotivationVerifyYourAccount) {
    self.verificationPhotoView = [VerificationPhotoView createVerificationPhotoView];
    self.verificationPhotoView.delegate = self;
    [Helpers showCustomView:self.verificationPhotoView];
  } else {
    // TODO: Next Logic
  }
}

- (void)closeMotivationYaStarView {
  [Helpers dismissCustomView:self.motivationYaStarView];
}

- (void)showServicesMotivationYaStarView {
  [Helpers dismissCustomView:self.motivationYaStarView];
  [self presentServicesScreen];
}

- (void)activateInvisibleMotivationInvisiblePopupView {
  [Helpers dismissCustomView:self.motivationInvisiblePopupView];
  [self presentServicesScreen];
}

- (void)closeMotivationInvisiblePopupView {
  [Helpers dismissCustomView:self.motivationInvisiblePopupView];
}

- (void)closeMotivationTranslatorPopupView {
  [Helpers dismissCustomView:self.motivationTranslatorPopupView];
}

- (void)activateTranslatorMotivationTranslatorPopupView {
  [Helpers dismissCustomView:self.motivationTranslatorPopupView];
  [self presentServicesScreen];
}

- (void)closeMotivationMatchProfilePopup {
  [Helpers dismissCustomView:self.motivationMatchProfilePopupView];
}

- (void)openChatMotivationMatchProfilePopup:(MatchMapping *)matchMapping {
  [Helpers dismissCustomView:self.motivationMatchProfilePopupView];
  
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
  ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
  
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [matchMapping.FromUserId integerValue]) {
    chatVC.profileMapping = matchMapping.ToUser;
  } else {
    chatVC.profileMapping = matchMapping.FromUser;
  }

  [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)closeMotivationPrivateProfilePopup {
  [Helpers dismissCustomView:self.motivationPrivateProfilePopupView];
}

- (void)openPrivateProfileMotivationPrivateProfilePopup {
  [Helpers dismissCustomView:self.motivationPrivateProfilePopupView];
  // TODO: Present My Private Profile
}

- (void)showGiftsScreen:(CustomButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  [self presentGiftScreen:YES];
}

- (void)sendRequestProfile:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"UserId" : self.profileMapping.UserId,
                           @"Level" : self.level};
  [self sendRequestWithParams:params];
}

- (void)cancelSendRequest:(UIButton *)sender {
  self.level = nil;
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
}

- (void)hideVerificationPhotoView {
  [Helpers dismissCustomView:self.verificationPhotoView];
}

- (void)presentGalleryVerificationPhotoView {
  [self presentPhotoGallery];
}

- (void)presentCameraVerificationPhotoView {
  [self presentCameraPhoto];
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

