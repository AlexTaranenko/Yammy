//
//  MyPrivateProfileViewController.m
//  Yammy
//
//  Created by Alex on 18.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyPrivateProfileViewController.h"
#import "MyTitlePrivateProfileTableViewCell.h"
#import "MyTitlePrivateProfileModel.h"
#import "MyPrivateProfileQuestionModel.h"
#import "AnswerPrivateProfileTableViewCell.h"
#import "SegmentPrivateProfileTableViewCell.h"
#import "SizeChestTableViewCell.h"
#import "SizePenisTableViewCell.h"
#import "MyPrivateProfileAssociationsTableViewCell.h"
#import "EditProfileView.h"
#import "UIViewController+Carousel.h"
#import "PrivateProfileMapping.h"
#import "UIViewController+ProfileInterface.h"
#import "HotPageImageCollectionViewCell.h"
#import "ProfileFormDetailViewController.h"
#import "PublicProfileAboutMeModel.h"
#import "SearchViewController.h"

typedef enum : NSUInteger {
  TotalInformationMyTitlePrivateProfileSection = 0,
  PrivateInterestMyTitlePrivateProfileSection,
  PrivateAssociationMyTitlePrivateProfileSection
} MyTitlePrivateProfileTableSection;

typedef enum : NSUInteger {
  FirstSexTotalInfoRow = 1,
  WhenSexTotalInfoRow,
  WhereSexTotalInfoRow,
} TotalInfoRow;

typedef enum : NSUInteger {
  WhenFirstSexRow = 2,
  OftenSexRow = 4,
} PrivateInterestRow;

static NSInteger const titleForTheFirstRow = 1;

@interface MyPrivateProfileViewController ()<UITableViewDelegate, UITableViewDataSource, EditProfileViewDelegate, MyPrivateProfileAssociationsTableViewCellDelegate, SegmentPrivateProfileTableViewCellDelegate, SizeChestTableViewCellDelegate, SizePenisTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ProfileFormDetailViewControllerDelegate, SearchViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *photosCountLabel;
@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *strawberryButtons;
@property (weak, nonatomic) IBOutlet UILabel *galleryHiddenLabel;

@property (strong, nonatomic) NSArray *titleOfSectionsArray;
@property (strong, nonatomic) NSArray *totalInfoArray;
@property (strong, nonatomic) NSArray *privateInterestArray;
@property (strong, nonatomic) NSArray *preferencesArray;

@property (strong, nonatomic) EditProfileView *editProfileView;
@property (strong, nonatomic) PrivateProfileMapping *privateProfileMapping;
@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@end

@implementation MyPrivateProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.publicProfileAboutMeModel = [[PublicProfileAboutMeModel alloc] init];
  [self.publicProfileAboutMeModel setupValuesByProfileMapping:[ServerManager sharedManager].myProfileMapping];
  
  [self setupTitleOfSections];
  [self setupTotalInformationArray];
  [self setupPrivateInterestArray];
  
  CGRect headerFrame = self.tableView.tableHeaderView.frame;
  headerFrame.size.height = [[UIScreen mainScreen] bounds].size.width + 10 + 66;
  self.tableView.tableHeaderView.frame = headerFrame;
  
  [self.tableView registerNib:[UINib nibWithNibName:@"SegmentPrivateProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kSegmentPrivateProfileCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"SegmentPrivateProfileShortTableViewCell" bundle:nil] forCellReuseIdentifier:kSegmentPrivateProfileShortCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"SizeChestTableViewCell" bundle:nil] forCellReuseIdentifier:kSizeChestCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"SizePenisTableViewCell" bundle:nil] forCellReuseIdentifier:kSizePenisCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"MyPrivateProfileAssociationsTableViewCell" bundle:nil] forCellReuseIdentifier:kMyPrivateProfileAssociationsCellIdentifier];
  [self.photosCollectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
  
  __weak typeof(self)weakSelf = self;
  self.uploadPhotoImageBlock = ^(BOOL status, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (status) {
        [weakSelf loadPrivateProfileFromServer];
      }
    });
  };
  
  [self setupLabelGesture];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self loadDictionariesFromServer];
}

#pragma mark - Private

- (void)setupLabelGesture {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [self.nameLabel addGestureRecognizer:tapGestureRecognizer];
  self.nameLabel.userInteractionEnabled = YES;
}

- (void)setupMainBlock {
  [Helpers prepareLabelsByProfileMapping:[ServerManager sharedManager].myProfileMapping withLabel:self.nameLabel];
  self.photosCountLabel.text = self.privateProfileMapping.Photos.count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)self.privateProfileMapping.Photos.count] : @"0";
}

- (void)loadDictionariesFromServer {
  dispatch_group_t group = dispatch_group_create();
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:FIRST_SEX_WITH_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updateTotalInformationArrayByAnswersArray:dictionaryListArray andObjectIndex:WithWhomFirstSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:FIRST_SEX_WHEN_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updateTotalInformationArrayByAnswersArray:dictionaryListArray andObjectIndex:WhenFirstSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:FIRST_SEX_WHERE_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updateTotalInformationArrayByAnswersArray:dictionaryListArray andObjectIndex:WhereWasFirstSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:READY_TO_NEW_SEX_HORIZON_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updateTotalInformationArrayByAnswersArray:dictionaryListArray andObjectIndex:NewSexualHorizons];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:HAVE_FILMED_HOME_SEX_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updatePrivateInterestsArrayByAnswersArray:dictionaryListArray andObjectIndex:HomeVideo];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:READY_TO_FIRST_SEX_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updatePrivateInterestsArrayByAnswersArray:dictionaryListArray andObjectIndex:WhenReadyFirstSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:SEX_PASSION_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updatePrivateInterestsArrayByAnswersArray:dictionaryListArray andObjectIndex:SpecialPassionsSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:SEX_FREQUENCY_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updatePrivateInterestsArrayByAnswersArray:dictionaryListArray andObjectIndex:OftenReadyHaveSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:VIRTUAL_SEX_LIST withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    [self updatePrivateInterestsArrayByAnswersArray:dictionaryListArray andObjectIndex:RelationshipVirtualSex];
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getDictionaryOfListByPath:GENDER withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.publicProfileAboutMeModel.genders = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
    [self loadPrivateProfileFromServer];
  });
}

- (void)loadPrivateProfileFromServer {
  [[ServerManager sharedManager] getPrivateProfileById:nil wirhCompletion:^(PrivateProfileMapping *privateProfileMapping, NSString *errorMessage) {
    if (privateProfileMapping) {
      self.privateProfileMapping = privateProfileMapping;
      [self setupMainBlock];
      [self addGalleryItemsToCarouselByArray:self.privateProfileMapping.Photos];
      [self updateTitleOfSectionsByPrivateProfileMapping:privateProfileMapping];
      [self updateTotalInformationArrayByPrivateProfileMapping:privateProfileMapping];
      [self updatePrivateInterestsArrayByPrivateProfileMapping:privateProfileMapping];
      [self prepareGelleryHiddenLabelByArray:self.titleOfSectionsArray];
      self.preferencesArray = privateProfileMapping.PrivatePreferences;
      self.pageControl.numberOfPages = self.privateProfileMapping.Photos.count;
      [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:[ServerManager sharedManager].myProfileMapping isMyProfile:YES];
      [self.tableView reloadData];
      [self.photosCollectionView reloadData];
    }
  }];
}

- (void)addGalleryItemsToCarouselByArray:(NSArray *)array {
  if (array.count == 0) {
    if (self.privateProfileMapping.PrimaryPhoto != nil) {
      self.photosArray = @[self.privateProfileMapping.PrimaryPhoto];
    } else {
      self.photosArray = @[@(1)];
    }
  } else {
    self.photosArray = array;
  }
}

- (void)setupTitleOfSections {
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel0 = [[MyTitlePrivateProfileModel alloc] initWithTitle:@"Геллерея" withIsShowInfo:@(0)];
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel1 = [[MyTitlePrivateProfileModel alloc] initWithTitle:@"Общие данные" withIsShowInfo:@(0)];
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel2 = [[MyTitlePrivateProfileModel alloc] initWithTitle:@"Приватные данные" withIsShowInfo:@(0)];
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel3 = [[MyTitlePrivateProfileModel alloc] initWithTitle:@"Приватные ассоциации" withIsShowInfo:@(0)];
  
  self.titleOfSectionsArray = @[myTitlePrivateProfileModel0, myTitlePrivateProfileModel1, myTitlePrivateProfileModel2, myTitlePrivateProfileModel3];
}

- (void)setupTotalInformationArray {
  NSMutableArray *mutArray = [NSMutableArray new];
  for (NSDictionary *dict in [MyPrivateProfileQuestionModel totalInformationQuestionsArrayByPrivateProfileMapping:nil]) {
    NSNumber * answerType = (NSNumber *)[dict objectForKey:@"answerType"];
    MyPrivateProfileQuestionModel *model = [[MyPrivateProfileQuestionModel alloc] initWithQuestion:[dict objectForKey:@"question"] withAnswer:nil withAnswers:[dict objectForKey:@"answers"] withAnswerType:[answerType integerValue]];
    [mutArray addObject:model];
  }
  
  self.totalInfoArray = mutArray;
}

- (void)setupPrivateInterestArray {
  NSMutableArray *mutArray = [NSMutableArray new];
  for (NSDictionary *dict in [MyPrivateProfileQuestionModel privateInterestQuestionsArray]) {
    NSNumber * answerType = (NSNumber *)[dict objectForKey:@"answerType"];
    MyPrivateProfileQuestionModel *model = [[MyPrivateProfileQuestionModel alloc] initWithQuestion:[dict objectForKey:@"question"] withAnswer:nil withAnswers:[dict objectForKey:@"answers"] withAnswerType:[answerType integerValue]];
    [mutArray addObject:model];
  }
  
  self.privateInterestArray = mutArray;
}

- (void)updateTotalInformationArrayByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  for (MyPrivateProfileQuestionModel *model in self.totalInfoArray) {
    NSInteger index = [self.totalInfoArray indexOfObject:model];
    model.answer = [model answerTotalInfoByNumberOfBlock:index withPrivateProfileMapping:privateProfileMapping];
  }
}

- (void)updatePrivateInterestsArrayByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  for (MyPrivateProfileQuestionModel *model in self.privateInterestArray) {
    NSInteger index = [self.privateInterestArray indexOfObject:model];
    model.answer = [model answerPrivateInterestsByNumberOfBlock:index withPrivateProfileMapping:privateProfileMapping];
  }
}

- (void)updateTitleOfSectionsByPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  for (MyTitlePrivateProfileModel *myTitlePrivateProfileModel in self.titleOfSectionsArray) {
    NSInteger index = [self.titleOfSectionsArray indexOfObject:myTitlePrivateProfileModel];
    myTitlePrivateProfileModel.isShowInfo = [myTitlePrivateProfileModel updateShowInfoByNumberOfBlock:index andPrivateProfileMapping:privateProfileMapping];
    [myTitlePrivateProfileModel updateTitleButtonByIsShowInfo:myTitlePrivateProfileModel.isShowInfo];
  }
}

- (void)updateTotalInformationArrayByAnswersArray:(NSArray *)answers andObjectIndex:(NSInteger)objectIndex {
  MyPrivateProfileQuestionModel *model = [self.totalInfoArray objectAtIndex:objectIndex];
  model.answers = answers;
}

- (void)updatePrivateInterestsArrayByAnswersArray:(NSArray *)answers andObjectIndex:(NSInteger)objectIndex {
  MyPrivateProfileQuestionModel *model = [self.privateInterestArray objectAtIndex:objectIndex];
  model.answers = answers;
}

- (void)prepareGelleryHiddenLabelByArray:(NSArray *)array {
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel = (MyTitlePrivateProfileModel *)[array firstObject];
  self.galleryHiddenLabel.text = myTitlePrivateProfileModel.titleButton;
}

#pragma mark - Collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photosArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
    [self presentFullImageControllerByPhotos:self.privateProfileMapping.Photos andIsMyProfile:YES andIndex:indexPath];
  }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.titleOfSectionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == TotalInformationMyTitlePrivateProfileSection) {
    return titleForTheFirstRow + self.totalInfoArray.count;
  } else if (section == PrivateInterestMyTitlePrivateProfileSection) {
    return titleForTheFirstRow + self.privateInterestArray.count;
  } else if (section == PrivateAssociationMyTitlePrivateProfileSection) {
    return titleForTheFirstRow;
  } else {
    return 0;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == TotalInformationMyTitlePrivateProfileSection) {
    if (indexPath.row == 0) {
      return [self prepareMyTitlePrivateProfileTableViewCellByIndexPath:indexPath];
    } else {
      return [self customizeTableViewCellByArray:self.totalInfoArray andIndexPath:indexPath];
    }
  } else if (indexPath.section == PrivateInterestMyTitlePrivateProfileSection) {
    if (indexPath.row == 0) {
      return [self prepareMyTitlePrivateProfileTableViewCellByIndexPath:indexPath];
    } else {
      return [self customizeTableViewCellByArray:self.privateInterestArray andIndexPath:indexPath];
    }
  } else if (indexPath.section == PrivateAssociationMyTitlePrivateProfileSection) {
    MyPrivateProfileAssociationsTableViewCell *myPrivateProfileAssociationsCell = [tableView dequeueReusableCellWithIdentifier:kMyPrivateProfileAssociationsCellIdentifier];
    myPrivateProfileAssociationsCell.delegate = self;
    [myPrivateProfileAssociationsCell prepareCollectionViewByPreferencesArray:self.preferencesArray];
    MyTitlePrivateProfileModel *myTitlePrivateProfileModel = [self.titleOfSectionsArray lastObject];
    [myPrivateProfileAssociationsCell prepareHideShowButton:myTitlePrivateProfileModel];
    return myPrivateProfileAssociationsCell;
  } else {
    return [UITableViewCell new];
  }
}

- (UITableViewCell *)customizeTableViewCellByArray:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath {
  MyPrivateProfileQuestionModel *model = [array objectAtIndex:indexPath.row - 1];
  //  if (model.answerType == SegmentAnswerType) {
  //    return [self prepareSegmentPrivateProfileTableViewCellByModel:model];
  //  } else if (model.answerType == SliderAnswerType) {
  //    if ([ServerManager sharedManager].myProfileMapping.SexId != nil && [[ServerManager sharedManager].myProfileMapping.SexId integerValue] == 1) {
  //      return [self prepareSizePenisTableViewCellByModel:model];
  //    } else {
  //      return [self prepareSizeChestTableViewCellByModel:model];
  //    }
  //  } else {
  return [self prepareAnswerPrivateProfileTableViewCellByModel:model];
  //  }
}

- (MyTitlePrivateProfileTableViewCell *)prepareMyTitlePrivateProfileTableViewCellByIndexPath:(NSIndexPath *)indexPath {
  MyTitlePrivateProfileTableViewCell *myTitlePrivateProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kMyTitlePrivateProfileCellIdentifier];
  MyTitlePrivateProfileModel *model = [self.titleOfSectionsArray objectAtIndex:indexPath.section + 1];
  myTitlePrivateProfileCell.myTitlePrivateProfileModel = model;
  [myTitlePrivateProfileCell prepareMyTitlePrivateProfileCellWithModel:model];
  return myTitlePrivateProfileCell;
}

- (AnswerPrivateProfileTableViewCell *)prepareAnswerPrivateProfileTableViewCellByModel:(MyPrivateProfileQuestionModel *)model {
  AnswerPrivateProfileTableViewCell *answerPrivateProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAnswerPrivateProfileCellIdentifier];
  answerPrivateProfileCell.myPrivateProfileQuestionModel = model;
  [answerPrivateProfileCell prepareAnswerPrivateProfileCellByModel:model];
  return answerPrivateProfileCell;
}

- (SegmentPrivateProfileTableViewCell *)prepareSegmentPrivateProfileTableViewCellByModel:(MyPrivateProfileQuestionModel *)model {
  SegmentPrivateProfileTableViewCell *segmentPrivateProfileTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:model.answers.count > 2 ? kSegmentPrivateProfileCellIdentifier : kSegmentPrivateProfileShortCellIdentifier];
  segmentPrivateProfileTableViewCell.delegate = self;
  
  segmentPrivateProfileTableViewCell.myPrivateProfileQuestionModel = model;
  if (model.answers.count > 2) {
    [segmentPrivateProfileTableViewCell prepareMoreInterface];
  } else {
    [segmentPrivateProfileTableViewCell prepareShortIntetface];
  }
  return segmentPrivateProfileTableViewCell;
}

- (SizeChestTableViewCell *)prepareSizeChestTableViewCellByModel:(MyPrivateProfileQuestionModel *)model {
  SizeChestTableViewCell *sizeChestCell = [self.tableView dequeueReusableCellWithIdentifier:kSizeChestCellIdentifier];
  sizeChestCell.delegate = self;
  sizeChestCell.myPrivateProfileQuestionModel = model;
  [sizeChestCell prepareSizeChestCellByModel:model];
  return sizeChestCell;
}

- (SizeChestTableViewCell *)prepareSizePenisTableViewCellByModel:(MyPrivateProfileQuestionModel *)model {
  SizeChestTableViewCell *sizeChestCell = [self.tableView dequeueReusableCellWithIdentifier:kSizeChestCellIdentifier];
  sizeChestCell.delegate = self;
  sizeChestCell.myPrivateProfileQuestionModel = model;
  [sizeChestCell prepareSizePenisCellByModel:model];
  return sizeChestCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == TotalInformationMyTitlePrivateProfileSection) {
    if (indexPath.row != 0) {
      [self presentEditViewByArray:self.totalInfoArray andIndexPath:indexPath];
      //      if (indexPath.row == FirstSexTotalInfoRow || indexPath.row == WhenSexTotalInfoRow) {
      //        [self presentEditViewByArray:self.totalInfoArray andIndexPath:indexPath];
      //      } else if (indexPath.row == WhereSexTotalInfoRow) {
      //
      //      }
    } else {
      [self reloadTableViewByIndexPath:indexPath];
    }
  } else if (indexPath.section == PrivateInterestMyTitlePrivateProfileSection) {
    if (indexPath.row != 0) {
      //      if (indexPath.row == WhenFirstSexRow || indexPath.row == OftenSexRow) {
      [self presentEditViewByArray:self.privateInterestArray andIndexPath:indexPath];
      //      }
    } else {
      [self reloadTableViewByIndexPath:indexPath];
    }
  } else {
    if (indexPath.row == 0) {
      [self reloadTableViewByIndexPath:indexPath];
    }
  }
}

- (void)presentEditViewByArray:(NSArray *)array andIndexPath:(NSIndexPath *)indexPath {
  dispatch_async(dispatch_get_main_queue(), ^{
    MyPrivateProfileQuestionModel *model = [array objectAtIndex:indexPath.row - 1];
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ProfileFormDetail" andStoryboardId:PROFILE_FORM_DETAIL_STORYBOARD_ID];
    ProfileFormDetailViewController *profileFormDetailVC = (ProfileFormDetailViewController *)[navVC topViewController];
    profileFormDetailVC.delegate = self;
    profileFormDetailVC.isAboutMe = YES;
    profileFormDetailVC.indexPath = indexPath;
    profileFormDetailVC.answersArray = model.answers;
    profileFormDetailVC.myPrivateProfileQuestionModel = model;
    [self.navigationController pushViewController:profileFormDetailVC animated:YES];
    //    }
  });
}

#pragma mark - Delegate

- (void)reloadTableViewByIndexPath:(NSIndexPath *)indexPath {
  [[ServerManager sharedManager] updatePrivateProfileWithParams:[self paramsForUpdateBlockByIndexPath:indexPath] withCompletion:^(BOOL status, NSString *errorMessage) {
    [self loadPrivateProfileFromServer];
  }];
  
  [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.editProfileView.alpha = 0.0;
  } completion:^(BOOL finished) {
    [self.editProfileView removeFromSuperview];
  }];
}

- (void)reloadTableViewBySelectIndexPath:(NSIndexPath *)indexPath {
  [[ServerManager sharedManager] updatePrivateProfileWithParams:[self paramsForUpdateBlockByIndexPath:indexPath] withCompletion:^(BOOL status, NSString *errorMessage) {
    [self loadPrivateProfileFromServer];
  }];
}

- (void)presentAssociationsVC {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Search" andStoryboardId:SEARCH_STORYBOARD_ID];
  SearchViewController *searchVC = (SearchViewController *)[navVC topViewController];
  searchVC.delegate = self;
  searchVC.privateProfileMapping = self.privateProfileMapping;
  [self.navigationController pushViewController:searchVC animated:YES];
  
}

- (void)selectSegmentPrivateProfileByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self reloadTableViewByIndexPath:indexPath];
}

- (void)finishedSizePenisByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self reloadTableViewByIndexPath:indexPath];
}

- (void)finishedSizeChestByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self reloadTableViewByIndexPath:indexPath];
}

- (void)updatePreferencesAtThePrivateProfileByAddedPreferencesArray:(NSArray *)addedPreferences {
  if (addedPreferences.count > 0) {
    NSMutableString *mutString = [NSMutableString new];
    for (PreferencesMapping *mapping in addedPreferences) {
      NSInteger index = [addedPreferences indexOfObject:mapping];
      [mutString appendFormat:@"%@", mapping.IdPreferences];
      if (index + 1 != addedPreferences.count) {
        [mutString appendString:@","];
      }
    }
    
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"PrivatePreferences" : mutString
                             };
    
    [[ServerManager sharedManager] updatePrivateProfileWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
      if (status) {
        [self loadPrivateProfileFromServer];
      }
    }];
  }
}

- (void)updatePublicProfileByPublicProfileAboutMeModel:(PublicProfileAboutMeModel *)publicProfileAboutMeModel {
  self.publicProfileAboutMeModel = publicProfileAboutMeModel;
  [Helpers showSpinner];
  [[ServerManager sharedManager] updateProfileWithParams:[self paramsForUpdateAboutMeWithPublicProfileAboutMeModel:self.publicProfileAboutMeModel] withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    
    [[ServerManager sharedManager] getProfileById:nil withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
      [ServerManager sharedManager].myProfileMapping = profileMapping;
      [self.publicProfileAboutMeModel setupValuesByProfileMapping:profileMapping];
      
      [self loadPrivateProfileFromServer];
    }];
  }];
}

- (void)showHidePrivateAssociation:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self reloadTableViewByIndexPath:indexPath];
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

- (IBAction)shareDidTap:(UIButton *)sender {
  [self presentShareControllerByProfileMapping:nil];
}

- (IBAction)openMenuDidTap:(UIButton *)sender {
  [self presentPopoverBySender:sender isEditPhoto:YES];
}


- (IBAction)showHideGalleryDidTap:(UIControl *)sender {
  MyTitlePrivateProfileModel *myTitlePrivateProfileModel = [self.titleOfSectionsArray firstObject];
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"IsHidden" : [myTitlePrivateProfileModel.isShowInfo boolValue] == NO ? @(1) : @(0)};
  
  [[ServerManager sharedManager] updatePrivateProfileWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self loadPrivateProfileFromServer];
    }
  }];
}

#pragma mark - Params

- (NSDictionary *)paramsForUpdateBlockByIndexPath:(NSIndexPath *)indexPath {
  NSMutableDictionary *mutDict = [NSMutableDictionary new];
  
  [mutDict setObject:[Helpers getAccessToken] forKey:@"Token"];
  
  if (indexPath.section == TotalInformationMyTitlePrivateProfileSection) {
    if (indexPath.row == 0) {
      
      MyTitlePrivateProfileModel *myTitlePrivateProfileModel = [self.titleOfSectionsArray objectAtIndex:indexPath.section + 1];
      [mutDict setObject:[myTitlePrivateProfileModel.isShowInfo boolValue] == NO ? @(1) : @(0) forKey:@"GeneralInfoHidden"];
    } else {
      
      MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel = [self.totalInfoArray objectAtIndex:indexPath.row - 1];
      if (myPrivateProfileQuestionModel.answer != nil) {
        if (indexPath.row - 1 == WithWhomFirstSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"FirstSexWith"];
        } else if (indexPath.row - 1 == WhenFirstSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"FirstSexWhen"];
        } else if (indexPath.row - 1 == WhereWasFirstSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"FirstSexWhere"];
        } else if (indexPath.row - 1 == NewSexualHorizons) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"ReadyToNewSexHorizons"];
        } else if (indexPath.row - 1 == PenisOrBreasSize) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"PenisLengthOrBreastSize"];
        }
      }
    }
  } else if (indexPath.section == PrivateInterestMyTitlePrivateProfileSection) {
    if (indexPath.row == 0) {
      MyTitlePrivateProfileModel *myTitlePrivateProfileModel = [self.titleOfSectionsArray objectAtIndex:indexPath.section + 1];
      [mutDict setObject:[myTitlePrivateProfileModel.isShowInfo boolValue] == NO ? @(1) : @(0) forKey:@"PrivateInterestsHidden"];
    } else {
      
      MyPrivateProfileQuestionModel *myPrivateProfileQuestionModel = [self.privateInterestArray objectAtIndex:indexPath.row - 1];
      if (myPrivateProfileQuestionModel.answer != nil) {
        if (indexPath.row - 1 == HomeVideo) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"HaveFilmedHomeSex"];
        } else if (indexPath.row - 1 == WhenReadyFirstSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"ReadyToFirstSex"];
        } else if (indexPath.row - 1 == OftenReadyHaveSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"SexFrequency"];
        } else if (indexPath.row - 1 == RelationshipVirtualSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"VirtualSex"];
        } else if (indexPath.row - 1 == SpecialPassionsSex) {
          [mutDict setObject:myPrivateProfileQuestionModel.answer forKey:@"SexPassions"];
        }
      }
    }
  } else if (indexPath.section == PrivateAssociationMyTitlePrivateProfileSection) {
    MyTitlePrivateProfileModel *myTitlePrivateProfileModel = [self.titleOfSectionsArray objectAtIndex:indexPath.section + 1];
    [mutDict setObject:[myTitlePrivateProfileModel.isShowInfo boolValue] == NO ? @(1) : @(0) forKey:@"PrivatePreferencesHidden"];
  }
  
  return mutDict;
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

