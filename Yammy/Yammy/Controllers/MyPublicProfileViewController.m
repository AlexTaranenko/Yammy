//
//  MyPublicProfileViewController.m
//  Yammy
//
//  Created by Alex on 27.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyPublicProfileViewController.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "InterestTableViewCell.h"
#import "ServiceCollectionViewCell.h"
#import "GiftCollectionViewCell.h"
#import "ProfileFormViewController.h"
#import "MyGiftsViewController.h"
#import "ServicesViewController.h"
#import "PublicProfileAboutMeModel.h"
#import "UIViewController+ProfileInterface.h"
#import "HotPageImageCollectionViewCell.h"
#import "UIViewController+Carousel.h"
#import "ProfileFormDetailViewController.h"

typedef enum : NSUInteger {
  AboutMeProfileFormTag = 10,
  InterestsProfileFormTag,
} ProfileFormButtonTag;

typedef enum : NSUInteger {
  GiftsShowAllButtonTag = 10,
  MyServicesShowAllButtonTag,
} ShowAllButtonTag;

@interface MyPublicProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, ProfileFormViewControllerDelegate, UITextFieldDelegate, ServicesViewControllerDelegate, ProfileFormDetailViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *interestTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *servicesCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutInterestTableHeight;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *profileFormButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *showAllButtonsArray;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *strawberryButtons;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSArray *tagsArray;
@property (strong, nonatomic) NSMutableArray *cellHeights;

@property (strong, nonatomic) JCCollectionViewTagFlowLayout *layout;

@property (strong, nonatomic) ProfileMapping *profileMapping;
@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@property (strong, nonatomic) NSArray *giftsArray;
@property (strong, nonatomic) NSArray *servicesArray;
@property (strong, nonatomic) UITextField *textField;

@end

@implementation MyPublicProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.cellHeights = [NSMutableArray array];
  
  self.publicProfileAboutMeModel = [[PublicProfileAboutMeModel alloc] init];
  
  [self setupShowAllButtons];
  [self setupTags];
    
  [self setupProfileButtons];
  
  [self loadDictionariesFromServer];
  
  [self.photoCollectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
  
  __weak typeof(self)weakSelf = self;
  self.uploadPhotoImageBlock = ^(BOOL status, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (status) {
        [weakSelf loadPublicProfileDataFromServer];
      }
    });
  };
  
  [self setupLabelGesture];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (self.profileMapping) {
    [self loadPublicProfileDataFromServer];
  }
}

#pragma mark - Private

- (void)setupLabelGesture {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [self.nameLabel addGestureRecognizer:tapGestureRecognizer];
  self.nameLabel.userInteractionEnabled = YES;
}

- (void)loadDictionariesFromServer {
  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:RELATIONSHIP_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.relationsArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:GENDER withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.genders = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getGenderListForInterestedIn:NO withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.InterestedGenders = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getGenderListForInterestedIn:NO withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.orientationsArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:LIVE_WITH_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.livesArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:KID_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.childrenArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:BODY_TYPE_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.bodyArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:SMOKING_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.smokingArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:ALCOHOL_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.alchogolArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:JOB_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.jobArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getLanguageListWithCompletion:^(NSArray *languageArray, NSString *errorMessage) {
    if (languageArray) {
      self.publicProfileAboutMeModel.languageArray = languageArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:TRAIT_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.traitArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self loadPublicProfileDataFromServer];
  });
}

- (void)loadPublicProfileDataFromServer {
  [[ServerManager sharedManager] getProfileById:nil withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
    if (profileMapping) {
      [ServerManager sharedManager].myProfileMapping = profileMapping;
      self.profileMapping = profileMapping;
      [self setupDefaultValues];
      
      if (self.profileMapping.FirstName.length == 0) {
        [self labelTapped];
      }
      
      [self addGalleryItemsToCarouselByArray:profileMapping.Photos];
      [self setupMainBlockByPublicProfileAboutMeModel:self.publicProfileAboutMeModel];
      self.aboutMeLabel.text = self.publicProfileAboutMeModel.InfoAbout;
      [self setupGiftsCollectionViewByArray:self.profileMapping.Gifts];
      [self setupServicesCollectionViewByArray:self.profileMapping.Services];
      [self prepareFlowLayout];
      [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:self.profileMapping isMyProfile:YES];
      [self.interestTableView reloadData];
      [self.photoCollectionView reloadData];
    }
  }];
}

- (void)setupDefaultValues {
  [self.publicProfileAboutMeModel setupValuesByProfileMapping:self.profileMapping];
}

- (void)setupMainBlockByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel {
  NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:[publicProfileAboutMeModel.BirthDate integerValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fromDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  
  [Helpers prepareLabelsByProfileMapping:self.profileMapping withLabel:self.nameLabel];
  self.photosCountLabel.text = self.profileMapping.Photos.count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)self.profileMapping.Photos.count] : @"0";
}

- (void)setupGiftsCollectionViewByArray:(NSArray *)array {
  self.giftsArray = array;
  [self.giftCollectionView reloadData];
}

- (void)setupServicesCollectionViewByArray:(NSArray *)array {
  self.servicesArray = array;
  [self.servicesCollectionView reloadData];
}

- (void)addGalleryItemsToCarouselByArray:(NSArray *)array {
  if (array.count == 0) {
    self.photosArray = @[@(1)];
  } else {
    self.photosArray = array;
  }
  
  self.pageControl.numberOfPages = self.photosArray.count;
}

- (void)setupShowAllButtons {
  int index = 0;
  for (UIButton *button in self.showAllButtonsArray) {
    button.tag = 10 + index;
    index += 1;
  }
}

- (void)setupTags {
  self.servicesCollectionView.tag = MyServicesPublicMyProfileTag;
  self.giftCollectionView.tag = GiftsPublicMyProfileTag;
  self.interestTableView.tag = InterestPublicMyProfileTableViewTag;
}

- (void)setupProfileButtons {
  int index = 0;
  for (UIButton *button in self.profileFormButtonsArray) {
    button.tag = 10 + index;
    index += 1;
  }
}

- (void)prepareFlowLayout {
  self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
  
  NSMutableArray *tagArray = [NSMutableArray new];
  for (InterestMapping *mapping in self.profileMapping.Interests) {
    [tagArray addObject:mapping.Title];
  }
  
  for (NSInteger i = 0; i < tagArray.count; i++) {
    id peek = [tagArray objectAtIndex:i];
    [tagArray replaceObjectAtIndex:i withObject:peek];
  }
  
  self.items = @[tagArray.copy];
  
  CGFloat height = 0.0;
  for (NSArray *tags in self.items) {
    [self.cellHeights addObject:@([self.layout calculateContentHeight:tags])];
    height = [self.layout calculateContentHeight:tags] + 5;
  }
  
  self.layoutInterestTableHeight.constant = height;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag == MyServicesPublicMyProfileTag) {
    return self.servicesArray.count;
  } else if (collectionView.tag == GiftsPublicMyProfileTag) {
    return self.giftsArray.count;
  } else {
    return self.photosArray.count;
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == MyServicesPublicMyProfileTag) {
    ServiceCollectionViewCell *myServiceCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCollectionCell" forIndexPath:indexPath];
    ServicesMapping *mapping = [self.servicesArray objectAtIndex:indexPath.row];
    [myServiceCollectionCell prepareServiceCollectionByServicesMapping:mapping];
    return myServiceCollectionCell;
  } else if (collectionView.tag == GiftsPublicMyProfileTag) {
    GiftCollectionViewCell *giftCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"giftCollectionCell" forIndexPath:indexPath];
    UserGiftMapping *mapping = [self.giftsArray objectAtIndex:indexPath.row];
    [giftCollectionCell prepareGiftCollectionByUserGiftMapping:mapping];
    return giftCollectionCell;
  } else {
    HotPageImageCollectionViewCell *hotPageImageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier forIndexPath:indexPath];
    id object = [self.photosArray objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[ImageMapping class]]) {
      ImageMapping *mapping = (ImageMapping *)object;
      [hotPageImageCollectionCell preparePhotoImageByImageMapping:mapping];
    } else {
      [hotPageImageCollectionCell preparePhotoImageByImageMapping:nil];
    }
    return hotPageImageCollectionCell;
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == MyServicesPublicMyProfileTag) {
    return CGSizeMake(78.0, 78.0);
  } else if (collectionView.tag == GiftsPublicMyProfileTag) {
    return CGSizeMake(70.0, 70.0);
  } else {
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  UICollectionView *collectionView = (UICollectionView *)scrollView;
  if (collectionView.tag != MyServicesPublicMyProfileTag && collectionView.tag != GiftsPublicMyProfileTag) {
    CGFloat pageWidth = self.photoCollectionView.frame.size.width;
    CGFloat currentPage = (self.photoCollectionView.contentOffset.x / pageWidth);
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
      self.pageControl.currentPage = currentPage + 1;
    } else {
      self.pageControl.currentPage = currentPage;
    }
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == MyServicesPublicMyProfileTag) {
    [self presentServices];
  } else if (collectionView.tag == GiftsPublicMyProfileTag) {
    [self presentMyGifts];
  } else {
    if (self.profileMapping.Photos.count > 0) {
      [self presentFullImageControllerByPhotos:self.profileMapping.Photos andIsMyProfile:YES andIndex:indexPath];
    }
  }
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [[self.cellHeights objectAtIndex:indexPath.row] floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  InterestTableViewCell *interestTableCell = [tableView dequeueReusableCellWithIdentifier:@"interestTableCell"];
  [interestTableCell prepareTagsByArray:[self.items objectAtIndex:indexPath.row]];
  return interestTableCell;
}

#pragma mark - Delegate

- (void)updatePublicProfileByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel {
  self.publicProfileAboutMeModel = publicProfileAboutMeModel;
  [Helpers showSpinner];
  [[ServerManager sharedManager] updateProfileWithParams:[self paramsForUpdateAboutMeWithPublicProfileAboutMeModel:self.publicProfileAboutMeModel] withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
  }];
}

- (void)reloadAboutMeSection {
  [self loadPublicProfileDataFromServer];
}

- (void)reloadMyPublicProfileServices {
  [self loadPublicProfileDataFromServer];
}

#pragma mark - Actions

- (void)labelTapped {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
  ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
  profileFormDetailVC.delegate = self;
  profileFormDetailVC.isAboutMe = YES;
  profileFormDetailVC.isMyName = YES;
  profileFormDetailVC.answersArray = self.publicProfileAboutMeModel.genders;
  profileFormDetailVC.publicProfileAboutMeModel = self.publicProfileAboutMeModel;
  [self.navigationController pushViewController:profileFormDetailVC animated:YES];
}

- (IBAction)openMenuDidTap:(UIButton *)sender {
  [self presentPopoverBySender:sender isEditPhoto:YES];
}

- (IBAction)showAllDidTap:(UIButton *)sender {
  if (sender.tag == GiftsShowAllButtonTag) {
    [self presentMyGifts];
  } else {
    [self presentServices];
  }
}

- (void)presentMyGifts {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"MyGifts" andStoryboardId:MY_GIFTS_STORYBOARD_ID];
  MyGiftsViewController *giftsVC = (MyGiftsViewController *)[navVC topViewController];
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)presentServices {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Services" andStoryboardId:SERVICES_STORYBOARD_ID];
  ServicesViewController *servicesVC = (ServicesViewController *)[navVC topViewController];
  servicesVC.delegate = self;
  [self.navigationController pushViewController:servicesVC animated:YES];
}

- (IBAction)showProfileFormForAboutInfo:(id)sender {
  [self showProfileFormShared:YES];
}
- (IBAction)showProfileFormForInterests:(id)sender {
  [self showProfileFormShared:NO];
}

- (IBAction)showProfileFormDidTap:(UIButton *)sender {
  [self showProfileFormShared:sender.tag == AboutMeProfileFormTag];
}

-(void)showProfileFormShared:(BOOL)aboutMe {
  [self setupDefaultValues];
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileForm" andStoryboardId:PROFILE_FORM_STORYBOARD_ID];
  ProfileFormViewController *profileFormVC = (ProfileFormViewController *)[navVC topViewController];
  profileFormVC.delegate = self;
  profileFormVC.isAboutMe = aboutMe ? YES : NO;
  profileFormVC.publicProfileAboutMeModel = aboutMe ? self.publicProfileAboutMeModel : nil;
  profileFormVC.userInterests = self.profileMapping.Interests;
  [self.navigationController pushViewController:profileFormVC animated:YES];
}

- (IBAction)shareDidTap:(UIButton *)sender {
  [self presentShareControllerByProfileMapping:nil];
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

