//
//  PublicProfileViewController.m
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PublicProfileViewController.h"
#import "GiftCollectionViewCell.h"
#import "ServiceCollectionViewCell.h"
#import "VerificationTableViewCell.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "InterestTableViewCell.h"
#import "UIViewController+Carousel.h"
#import "ChatViewController.h"
#import "UIViewController+ProfileInterface.h"
#import "GiftsViewController.h"
#import "HotPageImageCollectionViewCell.h"
#import "VerificationCollectionViewCell.h"

@interface PublicProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, GiftsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addGiftLabel;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *strawberryButtons;

@property (weak, nonatomic) IBOutlet UICollectionView *verificationCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *giftsCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *interestTableView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UILabel *countPhotosLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutInterestTableHeight;
@property (weak, nonatomic) IBOutlet CustomButton *kingButton;
@property (weak, nonatomic) IBOutlet CustomButton *recommendButton;
@property (weak, nonatomic) IBOutlet CustomButton *contactButton;

@property (strong, nonatomic) NSArray *itemsOfTags;
@property (strong, nonatomic) NSMutableArray *cellHeights;
@property (strong, nonatomic) NSArray *giftsArray;
@property (strong, nonatomic) NSArray *verificationsArray;

@property (strong, nonatomic) JCCollectionViewTagFlowLayout *layout;

@property (assign, nonatomic) BOOL isLiked;
@property (assign, nonatomic) BOOL isKingLiked;
@property (assign, nonatomic) BOOL isFavorite;

@end

@implementation PublicProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.cellHeights = [NSMutableArray array];
  self.verificationsArray = @[@"fb_verification_icon", @"instagram_verification_icon", @"google_verification_icon", @"vk_verification_icon", @"twitter_verification_icon", @"phone_verification_icon"];
  
  [self loadProfileFromServer];
  
  self.photosCollectionView.tag = PhotosPublicProfileTag;
  self.giftsCollectionView.tag = GiftsPublicProfileTag;
  self.verificationCollectionView.tag = VerificationPublicProfileTag;
  
  self.interestTableView.tag = InterestPublicProfileTableViewTag;
  
  self.addGiftLabel.text = @"Сделать подарок";
  
  [self.photosCollectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)prepareRecommendButton {
  if (self.profileMapping.SharingAllowed != nil && [self.profileMapping.SharingAllowed boolValue] == false) {
    self.recommendButton.hidden = YES;
  } else {
    self.recommendButton.hidden = NO;
    if ([self.profileMapping.IsBlocked boolValue]) {
      [self.recommendButton setTitle:@"Разблокировать" forState:UIControlStateNormal];
    } else {
      [self.recommendButton setTitle:@"Рекомендовать другу" forState:UIControlStateNormal];
    }
  }
}

- (void)prepareKingButton {
  if ([self.profileMapping.IsSuperLikedByMe boolValue]) {
    [self prepareBorderButton:self.kingButton];
  }
}

- (void)prepareContactButton {
  if ([self.profileMapping.IsMyContact boolValue]) {
    [self prepareBorderButton:self.contactButton];
  }
}

- (void)prepareBorderButton:(CustomButton *)customButton {
  customButton.borderWidth = 2.f;
  customButton.borderColor = RGB(249, 0, 64);
}

- (void)loadProfileFromServer {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getProfileById:self.profileMapping.UserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (profileMapping) {
      self.profileMapping = profileMapping;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self setupMainBlockByProfileMapping:self.profileMapping];
        [self addGalleryItemsToCarouselByArray:self.profileMapping.Photos];
        self.aboutMeLabel.text = self.profileMapping.InfoAbout;
        [self prepareFlowLayoutByProfileMapping:self.profileMapping];
        self.giftsArray = self.profileMapping.Gifts;
        self.pageControl.numberOfPages = self.photosArray.count;
        [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:self.profileMapping isMyProfile:NO];
        [self prepareKingButton];
        [self prepareContactButton];
        [self.giftsCollectionView reloadData];
        [self prepareRecommendButton];
        [self.photosCollectionView reloadData];
        [self.interestTableView reloadData];
        if (self.isLiked || self.isKingLiked || self.isFavorite) {
          [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_PROFILE_MAPPING object:self.profileMapping];
        }
      });
    }
  }];
}

- (void)setupMainBlockByProfileMapping:(ProfileMapping *)profileMapping {
  [Helpers prepareLabelsByProfileMapping:self.profileMapping withLabel:self.nameLabel];
  self.countPhotosLabel.text = profileMapping.Photos.count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)profileMapping.Photos.count] : @"0";
}

- (void)addGalleryItemsToCarouselByArray:(NSArray *)array {
  if (array.count > 0) {
    self.photosArray = array;
  } else if (self.profileMapping.PrimaryPhoto != nil) {
    self.photosArray = @[self.profileMapping.PrimaryPhoto];
  } else {
    self.photosArray = @[@(1)];
  }
}

- (void)prepareFlowLayoutByProfileMapping:(ProfileMapping *)profileMapping {
  self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
  
  NSMutableArray *tagArray = [NSMutableArray new];
  for (InterestMapping *mapping in profileMapping.Interests) {
    [tagArray addObject:mapping.Title];
  }
  
  for (NSInteger i = 0; i < tagArray.count; i++) {
    id peek = [tagArray objectAtIndex:i];
    [tagArray replaceObjectAtIndex:i withObject:peek];
  }
  
  self.itemsOfTags = @[tagArray.copy];
  
  CGFloat height = 0.0;
  for (NSArray *tags in self.itemsOfTags) {
    [self.cellHeights addObject:@([self.layout calculateContentHeight:tags])];
    height = [self.layout calculateContentHeight:tags] + 5;
  }
  
  self.layoutInterestTableHeight.constant = height;
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag == PhotosPublicProfileTag) {
    return self.photosArray.count;
  } else if (collectionView.tag == GiftsPublicProfileTag) {
    return self.giftsArray.count;
  } else {
    return self.verificationsArray.count;
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == PhotosPublicProfileTag) {
    HotPageImageCollectionViewCell *hotPageImageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier forIndexPath:indexPath];
    id object = [self.photosArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[ImageMapping class]]) {
      ImageMapping *mapping = (ImageMapping *)object;
      [hotPageImageCollectionCell preparePhotoImageByImageMapping:mapping];
    } else {
      [hotPageImageCollectionCell preparePhotoImageByImageMapping:nil];
    }
    return hotPageImageCollectionCell;
  } else if (collectionView.tag == GiftsPublicProfileTag) {
    GiftCollectionViewCell *giftCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"giftCollectionCell" forIndexPath:indexPath];
    UserGiftMapping *mapping = [self.giftsArray objectAtIndex:indexPath.row];
    [giftCollectionCell prepareGiftCollectionByUserGiftMapping:mapping];
    return giftCollectionCell;
  } else {
    VerificationCollectionViewCell *verificationCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kVerificationCollectionCellIdentifier forIndexPath:indexPath];
    NSString *imageName = [self.verificationsArray objectAtIndex:indexPath.row];
    [verificationCollectionCell prepareIconByName:imageName];
    return verificationCollectionCell;
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == PhotosPublicProfileTag) {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
  } else if (collectionView.tag == GiftsPublicProfileTag) {
    return CGSizeMake(70.0, 70.0);
  } else {
    return CGSizeMake(24.0, 24.0);
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == PhotosPublicProfileTag) {
    if (self.profileMapping.Photos.count > 0) {
      [self presentFullImageControllerByPhotos:self.profileMapping.Photos andIsMyProfile:NO andIndex:indexPath];
    }
  }
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[self.cellHeights objectAtIndex:indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.itemsOfTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  InterestTableViewCell *interestTableCell = [tableView dequeueReusableCellWithIdentifier:@"interestTableCell"];
  [interestTableCell prepareTagsByArray:[self.itemsOfTags objectAtIndex:indexPath.row]];
  return interestTableCell;
}

#pragma mark - Scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  UICollectionView *collectionView = (UICollectionView *)scrollView;
  if (collectionView.tag != GiftsPublicProfileTag && collectionView.tag != VerificationPublicProfileTag) {
    CGFloat pageWidth = self.photosCollectionView.frame.size.width;
    CGFloat currentPage = (self.photosCollectionView.contentOffset.x / pageWidth);
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
      self.pageControl.currentPage = currentPage + 1;
    } else {
      self.pageControl.currentPage = currentPage;
    }
  }
}

#pragma mark - Delegate

- (void)reloadGiftsAtTheProfile {
  [self loadProfileFromServer];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [WToast showWithText:@"Подарок отправлен" duration:3.0];
  });
}

#pragma mark - Action

- (IBAction)recommendDidTap:(CustomButton *)sender {
  if ([self.profileMapping.IsBlocked boolValue]) {
    
    [[ServerManager sharedManager] unblockUserByIdUser:self.profileMapping.UserId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [self loadProfileFromServer];
    }];
  } else {
    [self presentShareControllerByProfileMapping:self.profileMapping];
  }
}

- (IBAction)strawberryButtonDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentPrivateProfileVC];
  }
}

- (IBAction)chatDidTap:(UIButton *)sender {
  //  self.chatButton.selected = !sender.selected;
  [self presentChatVC];
}

- (IBAction)likeDidTap:(UIButton *)sender {
  [self presentLike];
}

- (IBAction)favouriteDidTap:(UIButton *)sender {
  [self presentFavourite];
}

- (IBAction)kingLikeDidTap:(UIButton *)sender {
  [self presentKingLike];
}

- (IBAction)reportDidTap:(CustomButton *)sender {
  [self presentReportAlertByProfileMapping:self.profileMapping];
}

- (IBAction)sendGiftDidTap:(UIControl *)sender {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.delegate = self;
  giftsVC.profileMapping = self.profileMapping;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)presentChatVC {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
  ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
  chatVC.profileMapping = self.profileMapping;
  [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)presentLike {
  if ([self.profileMapping.IsLikedByMe boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(0)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
      self.isLiked = YES;
      [Helpers hideSpinner];
      if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
        [self presentMotivationByPage:LikePage];
      }
      [self loadProfileFromServer];
    }];
  }
}

- (void)presentKingLike {
  if ([self.profileMapping.IsSuperLikedByMe boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(1)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
      self.isKingLiked = YES;
      [Helpers hideSpinner];
      if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
        [self presentMotivationByPage:KingLikePage];
      }
      [self loadProfileFromServer];
    }];
  }
}

- (void)presentFavourite {
  if ([self.profileMapping.IsMyContact boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] addContactToBookmarkByUserId:self.profileMapping.UserId withCompletion:^(BOOL status, NSString *errorMessage) {
      self.isFavorite = YES;
      [Helpers hideSpinner];
      [self loadProfileFromServer];
    }];
  }
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

