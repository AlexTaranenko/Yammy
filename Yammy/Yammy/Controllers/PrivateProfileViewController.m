//
//  PrivateProfileViewController.m
//  Yammy
//
//  Created by Alex on 26.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PrivateProfileViewController.h"
#import "UIViewController+Carousel.h"
#import "PrivateProfileMapping.h"
#import "PrivateProfileQuestionsModel.h"
#import "ChatViewController.h"
#import "HotPageImageCollectionViewCell.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "InterestTableViewCell.h"
#import "Yammy-Swift.h"
#import "GiftsViewController.h"
#import "CornerView.h"
#import "RequestShowPrivateProfileView.h"

typedef enum : NSUInteger {
  PhotoRequestPrivateProfileLevel = 0,
  TotalInfoRequestPrivateProfileLevel,
  InterestsRequestPrivateProfileLevel,
  AssociationRequestPrivateProfileLevel
} RequestPrivateProfileLevel;

@interface PrivateProfileViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OnlyPicturesDataSource, OnlyPicturesDelegate, GiftsViewControllerDelegate, RequestShowPrivateProfileViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countPhotosLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *totalInformationLabel;
@property (weak, nonatomic) IBOutlet UITableView *interestsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPrivateInterestsTableHeight;
@property (weak, nonatomic) IBOutlet UIView *containerOnlyPicturesView;
@property (weak, nonatomic) IBOutlet UILabel *privateAssociationLabel;

@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *strawberryButtons;

@property (weak, nonatomic) IBOutlet CornerView *blurPhotoContainer;
@property (weak, nonatomic) IBOutlet CornerView *blurTotalInfoContainer;
@property (weak, nonatomic) IBOutlet CornerView *blurPrivateAssociationContainer;
@property (weak, nonatomic) IBOutlet CornerView *blurInterestedContainer;

@property (weak, nonatomic) IBOutlet CustomButton *recommendButton;
@property (weak, nonatomic) IBOutlet CustomButton *kibgButton;

@property (strong, nonatomic) NSArray *totalInformationArray;
@property (strong, nonatomic) NSArray *preferencesArray;

@property (strong, nonatomic) JCCollectionViewTagFlowLayout *layout;
@property (strong, nonatomic) OnlyHorizontalPictures *onlyPictures;

@property (strong, nonatomic) NSArray *itemsOfTags;
@property (strong, nonatomic) NSMutableArray *cellHeights;
@property (strong, nonatomic) RequestShowPrivateProfileView *requestShowPrivateProfileView;

@property (assign, nonatomic) RequestPrivateProfileLevel requestPrivateProfileLevel;

@end

@implementation PrivateProfileViewController

- (OnlyHorizontalPictures *)onlyPictures {
  if (_onlyPictures == nil) {
    _onlyPictures = [[OnlyHorizontalPictures alloc] initWithFrame:CGRectMake(0, 0, self.containerOnlyPicturesView.frame.size.width, self.containerOnlyPicturesView.frame.size.height)];
    _onlyPictures.dataSource = self;
    _onlyPictures.delegate = self;
    _onlyPictures.backgroundColor = [UIColor clearColor];
    _onlyPictures.spacingColor = RGB(250, 250, 250);
    _onlyPictures.spacing = 4.0;
    _onlyPictures.gap = 36;
    
    _onlyPictures.layer.cornerRadius = 20.0;
    _onlyPictures.layer.masksToBounds = YES;
  }
  
  return _onlyPictures;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isShowPirvateProfile) {
    self.navigationItem.title = @"Приватный профиль";
    [self prepareBackBarButtonItem];
  }
  
  self.cellHeights = [NSMutableArray new];
  [self.containerOnlyPicturesView addSubview:self.onlyPictures];
  [self.photosCollectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
  [self preparePrivateAssociationLabel];
  [self prepareBlurPhoto:nil];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getPrivateProfileById:self.profileMapping.UserId wirhCompletion:^(PrivateProfileMapping *privateProfileMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (privateProfileMapping.UserId != nil) {
      self.privateProfileMapping = privateProfileMapping;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self prepareBlurPhoto:self.profileMapping];
        [self setupNameWithBirthday];
        [self addGalleryItemsToCarouselByArray:self.privateProfileMapping.Photos];
        self.pageControl.numberOfPages = self.photosArray.count;
        
        self.totalInformationArray = [PrivateProfileQuestionsModel prepareGeneralInfoByPrivateProfileMapping:self.privateProfileMapping withProfileMapping:self.profileMapping];
        NSArray *privateInterestsArray = [PrivateProfileQuestionsModel preparePrivateInterestsByPrivateProfileMapping:self.privateProfileMapping withProfileMapping:self.profileMapping];
        [self prepareInterestsTableByInterestsArray:privateInterestsArray];
        self.preferencesArray = self.privateProfileMapping.PrivatePreferences;
        
        [self prepareTotalInfoLabel];
        [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:self.profileMapping isMyProfile:NO];
        
        [self.photosCollectionView reloadData];
        [self.interestsTableView reloadData];
        [self.onlyPictures reloadData];
      });
    }
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [Helpers prepareStatusBarWithColor:[UIColor blackColor]];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:[UIColor blackColor]];
}

#pragma mark - Private

- (void)prepareKingButton {
  if ([self.profileMapping.IsSuperLikedByMe boolValue]) {
    self.kibgButton.borderWidth = 2.f;
    self.kibgButton.borderColor = RGB(249, 0, 64);
  }
}

- (void)prepareBlurPhoto:(ProfileMapping *)mapping {
  self.blurPhotoContainer.hidden = mapping != nil && [mapping.IsPrivateProfileHidden boolValue] ? NO : YES;
  self.blurTotalInfoContainer.hidden = mapping != nil && [mapping.IsPrivateProfileGeneralInfoHidden boolValue] ? NO : YES;
  self.blurPrivateAssociationContainer.hidden = mapping != nil && [mapping.IsPrivateProfilePrivatePreferencesHidden boolValue] ? NO : YES;
  self.blurInterestedContainer.hidden = mapping != nil && [mapping.IsPrivateProfilePrivateInteresetsHidden boolValue] ? NO : YES;
}

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

- (void)loadProfileFromServer {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getProfileById:self.profileMapping.UserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (profileMapping) {
      self.profileMapping = profileMapping;
      [self prepareRecommendButton];
      [self prepareKingButton];
      [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:self.profileMapping isMyProfile:NO];
      [self prepareBlurPhoto:self.profileMapping];
    }
  }];
}

- (void)setupNameWithBirthday {
  [Helpers prepareLabelsByProfileMapping:self.profileMapping withLabel:self.nameLabel];
  self.countPhotosLabel.text = self.privateProfileMapping.Photos.count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)self.privateProfileMapping.Photos.count] : @"0";
}

- (void)addGalleryItemsToCarouselByArray:(NSArray *)array {
  if (array.count > 0) {
    self.photosArray = array;
  } else if (self.privateProfileMapping.PrimaryPhoto != nil) {
    self.photosArray = @[self.privateProfileMapping.PrimaryPhoto];
  } else {
    self.photosArray = @[@(1)];
  }
}

- (void)prepareTotalInfoLabel {
  if (self.totalInformationArray.count > 0) {
    NSMutableString *mutString = [NSMutableString new];
    for (PrivateProfileQuestionsModel *model in self.totalInformationArray) {
      NSInteger index = [self.totalInformationArray indexOfObject:model];
      if (model.answer.length > 0) {
        [mutString appendString:model.answer];
        if (index + 1 != self.totalInformationArray.count) {
          [mutString appendString:@", "];
        }
      }
    }
    
    if (self.profileMapping != nil && [self.profileMapping.IsPrivateProfileGeneralInfoHidden boolValue]) {
      self.totalInformationLabel.text = @"qwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiopqwertyyuiop";
    } else {
      self.totalInformationLabel.text = mutString;
    }
  } else {
    self.totalInformationLabel.text = nil;
  }
}

- (void)prepareInterestsTableByInterestsArray:(NSArray *)privateInterestsArray {
  self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
  
  NSMutableArray *tagArray = [NSMutableArray new];
  for (PrivateProfileQuestionsModel *model in privateInterestsArray) {
    if (model.answer != nil) {
      [tagArray addObject:model.answer];
    }
  }
  
  for (NSInteger i = 0; i < tagArray.count; i++) {
    id peek = [tagArray objectAtIndex:i];
    [tagArray replaceObjectAtIndex:i withObject:peek];
  }
  
  self.itemsOfTags = @[tagArray.copy];
  
  CGFloat height = 0.0;
  for (NSArray *tags in self.itemsOfTags) {
    [self.cellHeights addObject:@([self.layout calculateContentHeight:tags])];
    height = [self.layout calculateContentHeight:tags];
  }
  
  if (self.profileMapping != nil && [self.profileMapping.IsPrivateProfilePrivateInteresetsHidden boolValue]) {
    self.layoutPrivateInterestsTableHeight.constant = 60;
  } else {
    self.layoutPrivateInterestsTableHeight.constant = height;
  }
}

- (void)preparePrivateAssociationLabel {
  NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithString:@"Приватные ассоциации – отличный повод начать общение" attributes:@{NSForegroundColorAttributeName : RGB(128, 128, 127)}];
  self.privateAssociationLabel.attributedText = mutAttrString;
}

- (void)presentChatController {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
  ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
  chatVC.profileMapping = self.profileMapping;
  [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)presentRequestPopup {
  self.requestShowPrivateProfileView = [RequestShowPrivateProfileView createRequestShowPrivateProfileView];
  self.requestShowPrivateProfileView.delegate = self;
  [self.requestShowPrivateProfileView prepareInterfaceByProfileMapping:self.profileMapping];
  [UIView transitionWithView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^ {
                    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.requestShowPrivateProfileView]; }
                  completion:nil];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photosArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HotPageImageCollectionViewCell *hotPageImageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier forIndexPath:indexPath];
  hotPageImageCollectionCell.profileMapping = self.profileMapping;
  id object = [self.photosArray objectAtIndex:indexPath.row];
  if ([object isKindOfClass:[ImageMapping class]]) {
    ImageMapping *mapping = (ImageMapping *)object;
    [hotPageImageCollectionCell preparePhotoImageByImageMapping:mapping];
  } else {
    [hotPageImageCollectionCell preparePhotoImageByImageMapping:nil];
  }
  return hotPageImageCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat pageWidth = self.photosCollectionView.frame.size.width;
  CGFloat currentPage = (self.photosCollectionView.contentOffset.x / pageWidth);
  
  if (0.0f != fmodf(currentPage, 1.0f)) {
    self.pageControl.currentPage = currentPage + 1;
  } else {
    self.pageControl.currentPage = currentPage;
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.privateProfileMapping.Photos.count > 0) {
    [self presentFullImageControllerByPhotos:self.privateProfileMapping.Photos andIsMyProfile:NO andIndex:indexPath];
  }
}

#pragma mark - Only Pictures

- (NSInteger)numberOfPictures {
  return self.preferencesArray.count;
}

- (NSInteger)visiblePictures {
  return self.preferencesArray.count;
}

- (void)pictureViews:(UIImageView *)imageView index:(NSInteger)index {
  if (self.preferencesArray.count > 0) {
    PreferencesMapping *mapping = [self.preferencesArray objectAtIndex:index];
    NSString *urlPath = mapping.Icon.Url;
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = imageView.frame.size.width * 1.5;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    
    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [imageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        });
      }];
    } else {
      imageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    imageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)pictureView:(UIImageView *)imageView didSelectAt:(NSInteger)index {
  
}

#pragma mark - TableView

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

#pragma mark - Delegate

- (void)reloadGiftsAtTheProfile {
  [self loadProfileFromServer];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [WToast showWithText:@"Подарок отправлен" duration:3.0];
  });
}

- (void)sendGiftBySelectGiftMapping:(GiftMapping *)giftMapping {
  [self requestPrivateProfileWithParams:[self paramsForRequestProfile:giftMapping]];
}

- (void)showGiftsScreen:(CustomButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  [self showGiftByMapping:nil];
}

- (void)sendRequestProfile:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  [self requestPrivateProfileWithParams:[self paramsForRequestProfile:nil]];
}

- (void)cancelSendRequest:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
}

#pragma mark - Action

- (void)backButtonDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)recommendDidTap:(UIButton *)sender {
  if ([self.profileMapping.IsBlocked boolValue]) {
    
    [[ServerManager sharedManager] unblockUserByIdUser:self.profileMapping.UserId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [self loadProfileFromServer];
    }];
  } else {
    [self presentShareControllerByProfileMapping:self.profileMapping];
  }
}

- (IBAction)likeDidTap:(UIButton *)sender {
  if ([self.profileMapping.IsLikedByMe boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(0)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
        [self presentMotivationByPage:LikePage];
      }
      [self loadProfileFromServer];
    }];
  }
}

- (IBAction)kingLikeDidTap:(UIButton *)sender {
  if ([self.profileMapping.IsSuperLikedByMe boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] sendLikeWithParams:@{@"Token" : [Helpers getAccessToken], @"ToUserId" : self.profileMapping.UserId, @"IsSuper" : @(1)} withCompletion:^(MatchMapping *matchMapping, NSNumber *statusCode, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (statusCode != nil && [statusCode isEqualToNumber:@(531)]) {
        [self presentMotivationByPage:KingLikePage];
      }
      [self loadProfileFromServer];
    }];
  }
}

- (IBAction)favouriteDidTap:(UIButton *)sender {
  if ([self.profileMapping.IsMyContact boolValue] == NO) {
    [Helpers showSpinner];
    [[ServerManager sharedManager] addContactToBookmarkByUserId:self.profileMapping.UserId withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
      [self loadProfileFromServer];
    }];
  }
}

- (IBAction)chatDidTap:(UIButton *)sender {
  [self presentChatController];
}

- (IBAction)reportDidTap:(UIButton *)sender {
  [self presentReportAlertByProfileMapping:self.profileMapping];
}

- (IBAction)giftDidTap:(id)sender {
  [self showGiftByMapping:self.profileMapping];
}

- (IBAction)requestPhotoDidTap:(CustomButton *)sender {
  self.requestPrivateProfileLevel = PhotoRequestPrivateProfileLevel;
  [self presentRequestPopup];
}

- (IBAction)requestTotalInfoDidTap:(CustomButton *)sender {
  self.requestPrivateProfileLevel = TotalInfoRequestPrivateProfileLevel;
  [self presentRequestPopup];
}

- (IBAction)requestAssociationDidTap:(CustomButton *)sender {
  self.requestPrivateProfileLevel = AssociationRequestPrivateProfileLevel;
  [self presentRequestPopup];
}

- (IBAction)requestInterestedDidTap:(CustomButton *)sender {
  self.requestPrivateProfileLevel = InterestsRequestPrivateProfileLevel;
  [self presentRequestPopup];
}

- (void)showGiftByMapping:(ProfileMapping *)profileMapping {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.delegate = self;
  giftsVC.profileMapping = profileMapping;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (NSDictionary *)paramsForRequestProfile:(GiftMapping *)giftMapping {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  [mutDict setObject:self.profileMapping.UserId forKey:@"UserId"];
  [mutDict setObject:@(self.requestPrivateProfileLevel) forKey:@"Level"];
  
  if (giftMapping) {
    [mutDict setObject:giftMapping.IdGift forKey:@"GiftId"];
  }
  
  return mutDict;
}

- (void)requestPrivateProfileWithParams:(NSDictionary *)params {
  [Helpers showSpinner];
  [[ServerManager sharedManager] requestPrivateProfileWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

