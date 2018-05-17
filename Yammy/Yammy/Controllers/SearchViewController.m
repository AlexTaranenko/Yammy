//
//  SearchViewController.m
//  Yammy
//
//  Created by Alex on 30.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SearchViewController.h"
#import "InterestMeRegisterTableViewCell.h"
#import "OrientationRegisterTableViewCell.h"
#import "AgeSearchTableViewCell.h"
#import "ShowingSearchTableViewCell.h"
#import "CountrySearchTableViewCell.h"
#import "DetailProfileFormSectionView.h"
#import "PopupProfileFormTableViewCell.h"
#import "CornerView.h"
#import "DragView.h"
#import "AddedCirclesCollectionViewCell.h"
#import "CirclesCollectionViewCell.h"
#import "AssociationModel.h"

typedef enum : NSUInteger {
  ParametersSearchButtonTag = 10,
  AssociationSearchButtonTag
} SearchButtonTag;

typedef enum : NSUInteger {
  AddedCirclesCollectionViewTag = 10,
  CirclesCollectionView
} SearchPrivateCollectionViewTag;

static NSInteger kSearchSections = 4;
static CGFloat kHeightCollectionCell = 50.0f;

typedef enum : NSUInteger {
  MaxSearchType = 10,
  AnySearchType
} SearchMatchType;

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, CountrySearchTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutletCollection(UIControl) NSArray *searchButtonsArray;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineViewArray;
@property (weak, nonatomic) IBOutlet UIView *associationContainerView;

@property (weak, nonatomic) IBOutlet AutoCornerView *targetView;
@property (weak, nonatomic) IBOutlet UICollectionView *addedCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *circleCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *plusImageView;
@property (weak, nonatomic) IBOutlet CustomButton *nextButtons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSegmentContainerHeight;
@property (strong, nonatomic) IBOutletCollection(UIControl) NSArray *matcheControlArray;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *matchImageViewArray;

@property (strong, nonatomic) NSArray *orientationsArray;

@property (strong, nonatomic) NSArray *countriesArray;

@property (strong, nonatomic) NSArray *titlesArray;
@property (assign, nonatomic) BOOL dragEnabled;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) DragView *dragView;
@property (strong, nonatomic) PreferencesMapping *preferencesMapping;

@property (strong, nonatomic) AssociationModel *associationModel;

@property (assign, nonatomic) SearchButtonTag searchButtonTag;

@property (assign, nonatomic) SearchMatchType searchMatchType;

@end

@implementation SearchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.titlesArray = @[@"Всех", @"Онлайн", @"Новых"];
  self.dragEnabled = NO;
  
  if (self.searchModel.searchType != nil) {
    self.searchMatchType = [self.searchModel.searchType integerValue];
  } else {
    self.searchMatchType = MaxSearchType;
  }
  
  [self prepareMatchButtonsBySelected:self.searchMatchType];
  
  self.associationModel = [[AssociationModel alloc] init];
  self.addedCollectionView.tag = AddedCirclesCollectionViewTag;
  
  [self setupTargetView];
  
  [self prepareBackBarButtonItem];
  
  [self prepareSearchButtonsByTag:self.privateProfileMapping != nil ? AssociationSearchButtonTag : ParametersSearchButtonTag];
  [self hiddenAssociationContainer:self.privateProfileMapping != nil ? AssociationSearchButtonTag : ParametersSearchButtonTag];
  
  if (self.privateProfileMapping != nil) {
    self.layoutSegmentContainerHeight.constant = 0;
    [self loadCirclesFromServerAndAddedCircles:self.privateProfileMapping.PrivatePreferences];
  } else {
    [[ServerManager sharedManager] getPrivateProfileById:@(0) wirhCompletion:^(PrivateProfileMapping *privateProfileMapping, NSString *errorMessage) {
      if (self.searchModel.preferencesArray.count > 0) {
        [self loadCirclesFromServerAndAddedCircles:self.searchModel.preferencesArray];
      } else {
        [self loadCirclesFromServerAndAddedCircles:privateProfileMapping.PrivatePreferences];
      }
    }];
  }
  
  dispatch_group_t group = dispatch_group_create();
  [Helpers showSpinner];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getGenderListForInterestedIn:YES withCompletion:^(NSArray *dictionaryListArray, NSString *errorMessage) {
    if (dictionaryListArray) {
      self.orientationsArray = dictionaryListArray;
    }
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [Helpers hideSpinner];
    [self.tableView reloadData];
  });
  
  
  UILongPressGestureRecognizer *longCircleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleCircleDrag:)];
  longCircleGesture.minimumPressDuration = 0.1;
  [self.circleCollectionView addGestureRecognizer:longCircleGesture];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self setupDragItem];
  });
  
  [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"PopupProfileFormTextFieldCell" bundle:nil] forCellReuseIdentifier:kPopupProfileFormTextFieldCellIdentifier];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (![self tabBarIsVisible]) {
    __weak typeof(self) weakSelf = self;
    [self setTabBarVisible:![self tabBarIsVisible] animated:YES completion:^(BOOL finished) {
      [weakSelf.tabBarController.tabBar setHidden:NO];
    }];
  }
}

#pragma mark - Private

- (void)loadCirclesFromServerAndAddedCircles:(NSArray *)addedCircles {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getPreferenceswithCompletion:^(NSArray *preferencesArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (preferencesArray) {
      [self.associationModel prepareCirclesArray:preferencesArray];
      [self reloadCollectionViewsAfterUpdateByArray:addedCircles];
    }
  }];
}

- (void)setupTargetView {
  self.targetView.borderWidth = @(3.0);
  self.targetView.borderColor = RGB(237, 237, 237);
  self.targetView.lineCap = kCALineCapSquare;
  self.targetView.lineDashPattern = @[@10];
}

- (void)setupDragItem {
  self.dragView = [[DragView alloc] initWithFrame:CGRectMake(0, 0, kHeightCollectionCell, kHeightCollectionCell)];
  [self updateDragViewFrameIsAddedCircle:NO];
  self.dragView.clipsToBounds = YES;
  self.dragView.contentMode = UIViewContentModeScaleAspectFit;
  self.dragView.alpha = 0.0;
}

- (void)updateDragViewFrameIsAddedCircle:(BOOL)isAddedCircle {
  self.dragView.frame = CGRectMake(0, 0, kHeightCollectionCell, kHeightCollectionCell);
  self.dragView.layer.cornerRadius = self.dragView.frame.size.height / 2.f;
}

- (void)reloadCollectionViewsAfterUpdateByArray:(NSArray *)array {
  [self.associationModel prepareAddedCirclesArrayByArray:array];
  [self.associationModel filteredCirclesArray];
  [self.circleCollectionView reloadData];
  [self.addedCollectionView reloadData];
  [self hiddenPlusImageWithNextButton];
}

- (void)prepareSearchButtonsByTag:(NSInteger)tag {
  for (UIControl *control in self.searchButtonsArray) {
    NSInteger index = [self.searchButtonsArray indexOfObject:control];
    control.tag = index + 10;
    UIView *line = [self.lineViewArray objectAtIndex:index];
    self.searchButtonTag = tag;
    if (control.tag == tag) {
      line.backgroundColor = RGB(249, 0, 64);
    } else {
      line.backgroundColor = [UIColor clearColor];
    }
  }
}

- (void)hiddenAssociationContainer:(NSInteger)tag {
  if (tag == AssociationSearchButtonTag) {
    self.associationContainerView.hidden = NO;
  } else {
    self.associationContainerView.hidden = YES;
  }
}

- (void)hiddenPlusImageWithNextButton {
  if (self.associationModel.addedCirclesArray.count > 0) {
    self.plusImageView.hidden = YES;
    self.nextButtons.hidden = NO;
  } else {
    self.plusImageView.hidden = NO;
    self.nextButtons.hidden = YES;
  }
}

- (void)prepareMatchButtonsBySelected:(SearchMatchType)searchMatchType {
  for (UIControl *control in self.matcheControlArray) {
    NSInteger index = [self.matcheControlArray indexOfObject:control];
    control.tag = 10 + index;
    UIImageView *imageView = [self.matchImageViewArray objectAtIndex:index];
    if (control.tag == searchMatchType) {
      imageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
    } else {
      imageView.image = [UIImage imageNamed:@"select_person_register_icon"];
    }
  }
}

#pragma mark - Table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 41.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return 41.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == InterestPersonSearchSection) {
    return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Меня интересует"];
  } else if (section == AgeSearchSection) {
    return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Возраст"];
  } else if (section == ShowSearchSection) {
    return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Кого показывать"];
  } else {
    return [DetailProfileFormSectionView createDetailProfileFormSectionView:@"Местоположение"];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kSearchSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == InterestPersonSearchSection) {
    return self.orientationsArray.count;
  } else if (section == AgeSearchSection) {
    return 1;
  } else if (section == ShowSearchSection) {
    return self.titlesArray.count;
  } else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == InterestPersonSearchSection) {
    PopupProfileFormTableViewCell *popupProfileFormTableViewCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
    DictionaryMapping *mapping = [self.orientationsArray objectAtIndex:indexPath.row];
    [popupProfileFormTableViewCell prepareSecondTitleByText:mapping.Title];
    
    NSArray *filteredArray = [self.searchModel filteredOrientationsArrayById:mapping.IdDictionary];
    if (filteredArray.count > 0) {
      [popupProfileFormTableViewCell prepareInterestIconImageViewBySelected:YES];
    } else {
      [popupProfileFormTableViewCell prepareInterestIconImageViewBySelected:NO];
    }
    
    return popupProfileFormTableViewCell;
  } else if (indexPath.section == AgeSearchSection) {
    AgeSearchTableViewCell *ageSearchCell = [tableView dequeueReusableCellWithIdentifier:@"ageSearchCell"];
    ageSearchCell.searchModel = self.searchModel;
    [ageSearchCell prepareRangeSliderBySearchModel:self.searchModel];
    return ageSearchCell;
  } else if (indexPath.section == ShowSearchSection) {
    PopupProfileFormTableViewCell *popupProfileFormTableViewCell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormCellIdentifier];
    NSString *title = [self.titlesArray objectAtIndex:indexPath.row];
    [popupProfileFormTableViewCell prepareSecondTitleByText:title];
    
    if ([self.searchModel.showingUsers  isEqual: @(indexPath.row)]) {
      [popupProfileFormTableViewCell prepareSelectPersonIconImageViewBySelected:YES];
    } else {
      [popupProfileFormTableViewCell prepareSelectPersonIconImageViewBySelected:NO];
    }
    return popupProfileFormTableViewCell;
  } else if (indexPath.section == LocationSearchSection) {
    PopupProfileFormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPopupProfileFormTextFieldCellIdentifier];
    cell.searchModel = self.searchModel;
    [cell prepareTextFieldByTag:12 andText:self.searchModel.City andPlaceholder:@"Введите название города"];
    return cell;
  } else {
    return [UITableViewCell new];
  }
}

- (InterestMeRegisterTableViewCell *)prepareInterestMeRegisterTableViewCellByIndexPath:(NSIndexPath *)indexPath andTitle:(NSString *)title {
  InterestMeRegisterTableViewCell *interestMeRegisterTableCell = [self.tableView dequeueReusableCellWithIdentifier:@"interestMeRegisterTableCell"];
  if (indexPath.section == InterestPersonSearchSection) {
    interestMeRegisterTableCell.separatorInset = UIEdgeInsetsMake(0, self.tableView.frame.size.width, 0, 0);
  }
  interestMeRegisterTableCell.titleText = title;
  return interestMeRegisterTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == InterestPersonSearchSection) {
    DictionaryMapping *mapping = [self.orientationsArray objectAtIndex:indexPath.row];
    NSArray *filteredArray = [self.searchModel filteredOrientationsArrayById:mapping.IdDictionary];
    if (filteredArray.count > 0) {
      NSInteger index = [self.searchModel.orientationsArray indexOfObject:mapping];
      [self.searchModel.orientationsArray removeObjectAtIndex:index];
    } else {
      [self.searchModel.orientationsArray addObject:mapping];
    }
    [self.tableView reloadData];
  } else if (indexPath.section == ShowSearchSection) {
    self.searchModel.showingUsers = @(indexPath.row);
    [self.tableView reloadData];
  }
}

#pragma mark - Collection View

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(kHeightCollectionCell, kHeightCollectionCell);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag == AddedCirclesCollectionViewTag) {
    return self.associationModel.addedCirclesArray.count;
  } else {
    return self.associationModel.circlesArray.count;
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == AddedCirclesCollectionViewTag) {
    AddedCirclesCollectionViewCell *addedCirclesCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addedCirclesCollectionCell" forIndexPath:indexPath];
    PreferencesMapping *preferencesMapping = [self.associationModel.addedCirclesArray objectAtIndex:indexPath.row];
    addedCirclesCollectionCell.preferencesMapping = preferencesMapping;
    [addedCirclesCollectionCell setupRound];
    
    return addedCirclesCollectionCell;
  } else {
    CirclesCollectionViewCell *circlesCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"circlesCollectionCell" forIndexPath:indexPath];
    PreferencesMapping *preferencesMapping = [self.associationModel.circlesArray objectAtIndex:indexPath.row];
    circlesCollectionCell.preferencesMapping = preferencesMapping;
    [circlesCollectionCell setupRoundCell];
    return circlesCollectionCell;
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == AddedCirclesCollectionViewTag) {
    self.selectedIndexPath = indexPath;
    self.preferencesMapping = [self.associationModel.addedCirclesArray objectAtIndex:self.selectedIndexPath.row];

    [self.associationModel.addedCirclesArray removeObjectAtIndex:self.selectedIndexPath.row];
    [self.associationModel.circlesArray addObject:self.preferencesMapping];
    self.selectedIndexPath = nil;
    self.preferencesMapping = nil;
  } else {
    PreferencesMapping *mapping = [self.associationModel.circlesArray objectAtIndex:indexPath.row];
    [self.associationModel.addedCirclesArray addObject:mapping];
    [self.associationModel.circlesArray removeObjectAtIndex:indexPath.row];
  }
  
  [self hiddenPlusImageWithNextButton];
  [self.addedCollectionView reloadData];
  [self.circleCollectionView reloadData];
}

#pragma mark - Delegate

- (void)selectLocationByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  CountryMapping *countryMapping = [self.countriesArray objectAtIndex:indexPath.row - 1];
  [self.searchModel selectCountryByIdLocation:countryMapping.IdLocation];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:LocationSearchSection] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Handle Added Circle

//- (void)handleAddedCircleDrag:(UILongPressGestureRecognizer *)pan {
//  if (pan.state == UIGestureRecognizerStateBegan) {
//    [self addedCircleDragBeganByGesture:pan];
//  } else if (pan.state == UIGestureRecognizerStateEnded) {
//    if (self.dragEnabled == YES) {
//      self.dragEnabled = NO;
//
//      CGPoint point = [pan locationInView:self.circleCollectionView];
//      self.dragView.center = point;
//      if ([self isValidDragPoint:point]) {
//        [self setupAddCircleToMoreCircles];
//      } else {
//        [self addedCircleEndDrag];
//      }
//    }
//  } else if (self.dragEnabled == YES) {
//    self.dragView.center = [pan locationInView:self.view];
//  }
//}
//
//- (void)addedCircleDragBeganByGesture:(UILongPressGestureRecognizer *)pan {
//  if (self.selectedIndexPath == nil) {
//    CGPoint touch = [pan locationInView:self.addedCollectionView];
//    NSIndexPath *indexPath = [self.addedCollectionView indexPathForItemAtPoint:touch];
//    self.selectedIndexPath = indexPath;
//
//    if (indexPath != nil) {
//      [self updateDragViewFrameIsAddedCircle:YES];
//
//      [self showDragViewByArray:self.associationModel.addedCirclesArray withGesture:pan andIndexPath:indexPath];
//
//      [self.addedCollectionView performBatchUpdates:^{
//        [self.associationModel.addedCirclesArray removeObjectAtIndex:indexPath.row];
//        [self.addedCollectionView deleteItemsAtIndexPaths:@[indexPath]];
//      } completion:nil];
//
//      self.dragEnabled = YES;
//      self.addedCollectionView.userInteractionEnabled = NO;
//    }
//  }
//}
//
//- (BOOL)isValidDragPoint:(CGPoint)point {
//  return point.y > 0;
//}
//
//- (void)addedCircleEndDrag {
//  [UIView animateWithDuration:0.2 animations:^{
//
//  } completion:^(BOOL finished) {
//    [self.addedCollectionView performBatchUpdates:^{
//      [self.associationModel.addedCirclesArray insertObject:self.preferencesMapping atIndex:self.selectedIndexPath.row];
//      [self.addedCollectionView insertItemsAtIndexPaths:@[self.selectedIndexPath]];
//    } completion:^(BOOL finished) {
//      if (self.selectedIndexPath.item == (self.associationModel.addedCirclesArray.count - 1)) {
//        [self.addedCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
//      }
//      [self resetPropertiesIsAddedCircle:YES];
//    }];
//  }];
//}
//
//- (void)setupAddCircleToMoreCircles {
//  self.dragView.alpha = 0.0;
//  [self.associationModel.circlesArray addObject:self.preferencesMapping];
//  [self.circleCollectionView reloadData];
//  [self resetPropertiesIsAddedCircle:YES];
//}

#pragma mark - Handle Circle

- (void)handleCircleDrag:(UILongPressGestureRecognizer *)pan {
  if (pan.state == UIGestureRecognizerStateBegan) {
    [self circleDragBeganByGesture:pan];
  } else if (pan.state == UIGestureRecognizerStateEnded) {
    if (self.dragEnabled == YES) {
      self.dragEnabled = NO;
      
      CGPoint p1 = [self.targetView convertPoint:CGPointMake(self.targetView.frame.size.height / 2.0, self.targetView.frame.size.height / 2.0) toView:self.view];
      CGPoint p2 = self.dragView.center;
      
      CGFloat distance = sqrt(pow(fabs(p1.x - p2.x), 2) + pow(fabs(p1.y - p2.y), 2));
      if (distance < self.targetView.frame.size.width) {
        [self setupStartPoint:p1];
      } else {
        [self setupEndPoint];
      }
    }
  } else if (self.dragEnabled == YES) {
    self.dragView.center = [pan locationInView:self.view];
  }
}

- (void)circleDragBeganByGesture:(UILongPressGestureRecognizer *)pan {
  if (self.selectedIndexPath == nil) {
    CGPoint touch = [pan locationInView:self.circleCollectionView];
    NSIndexPath *indexPath = [self.circleCollectionView indexPathForItemAtPoint:touch];
    
    self.selectedIndexPath = indexPath;
    if (indexPath != nil) {
      
      [self updateDragViewFrameIsAddedCircle:NO];
      
      [self showDragViewByArray:self.associationModel.circlesArray withGesture:pan andIndexPath:indexPath];
      
      [self.circleCollectionView performBatchUpdates:^{
        [self.associationModel.circlesArray removeObjectAtIndex:indexPath.row];
        [self.circleCollectionView deleteItemsAtIndexPaths:@[indexPath]];
      } completion:nil];
      
      self.dragEnabled = YES;
      self.circleCollectionView.userInteractionEnabled = NO;
    }
  }
}

- (void)setupStartPoint:(CGPoint)point {
  [UIView animateWithDuration:0.2 animations:^{
    self.dragView.center = point;
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.1 animations:^{
      self.dragView.alpha = 0.0;
    } completion:^(BOOL finished) {
      [self.associationModel.addedCirclesArray addObject:self.preferencesMapping];
      [self.addedCollectionView reloadData];
      [self resetPropertiesIsAddedCircle:NO];
    }];
  }];
}

- (void)setupEndPoint {
  self.dragView.alpha = 0.0;
  [UIView animateWithDuration:0.2 animations:^{
    
  } completion:^(BOOL finished) {
    [self.circleCollectionView performBatchUpdates:^{
      [self.associationModel.circlesArray insertObject:self.preferencesMapping atIndex:self.selectedIndexPath.row];
      [self.circleCollectionView insertItemsAtIndexPaths:@[self.selectedIndexPath]];
    } completion:^(BOOL finished) {
      if (self.selectedIndexPath.item == (self.associationModel.circlesArray.count - 1)) {
        [self.circleCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
      }
      [self resetPropertiesIsAddedCircle:NO];
    }];
  }];
}

- (void)resetPropertiesIsAddedCircle:(BOOL)isAdded {
  [self.dragView removeFromSuperview];
  self.selectedIndexPath = nil;
  self.preferencesMapping = nil;
  if (isAdded) {
    self.addedCollectionView.userInteractionEnabled = YES;
  } else {
    self.circleCollectionView.userInteractionEnabled = YES;
  }
  
  [self hiddenPlusImageWithNextButton];
}

- (void)showDragViewByArray:(NSArray *)array withGesture:(UILongPressGestureRecognizer *)pan andIndexPath:(NSIndexPath *)indexPath {
  self.preferencesMapping = [array objectAtIndex:indexPath.row];
  self.dragView.preferencesMapping = self.preferencesMapping;
  [self.view addSubview:self.dragView];
  self.dragView.center = [pan locationInView:self.view];
  self.dragView.alpha = 1.0;
}

#pragma mark - Action

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButtonDidTap:(UIControl *)sender {
  if (self.privateProfileMapping == nil) {
    [self prepareSearchButtonsByTag:sender.tag];
    [self hiddenAssociationContainer:sender.tag];
  }
}

- (IBAction)successDidTap:(UIButton *)sender {
  
  if (self.privateProfileMapping != nil) {
    if (self.delegate != nil) {
      [self.delegate updatePreferencesAtThePrivateProfileByAddedPreferencesArray:self.associationModel.addedCirclesArray];
      [self.navigationController popToRootViewControllerAnimated:YES];
      return;
    }
  } else {
    
    // Body
    if (self.searchButtonTag == ParametersSearchButtonTag) {
      NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
      
      if (self.searchModel.orientationsArray.count > 0) {
        NSMutableString *mutString = [NSMutableString new];
        
        for (DictionaryMapping *mapping in self.searchModel.orientationsArray) {
          NSInteger index = [self.searchModel.orientationsArray indexOfObject:mapping];
          [mutString appendFormat:@"%ld", (long)[mapping.IdDictionary integerValue]];
          if (index + 1 != self.searchModel.orientationsArray.count) {
            [mutString appendString:@","];
          }
        }
        
        [mutDict setObject:mutString forKey:@"GenderId"];
      } else {
        [mutDict setObject:@"" forKey:@"GenderId"];
      }
      
      [mutDict setObject:self.searchModel.minAge forKey:@"AgeMin"];
      [mutDict setObject:self.searchModel.maxAge forKey:@"AgeMax"];
      
      if (self.searchModel.Latitude != nil && self.searchModel.Longitude) {
        [mutDict setObject:self.searchModel.Latitude forKey:@"Latitude"];
        [mutDict setObject:self.searchModel.Longitude forKey:@"Longitude"];
      }

      [mutDict setObject:self.searchModel.showingUsers forKey:@"Filter"];
      if (self.delegate != nil) {
        [self.delegate getSearchGeneralWithParams:mutDict];
      }
      
      [self.searchModel saveParamsWithSearchModel:self.searchModel];
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      [self searchAssociation];
      [self.navigationController popToRootViewControllerAnimated:YES];
    }
  }
}

- (void)searchAssociation {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  
  if (self.searchModel.genderId != nil) {
    [mutDict setObject:self.searchModel.genderId forKey:@"GenderId"];
  }
  
  [mutDict setObject:self.searchModel.minAge forKey:@"AgeMin"];
  [mutDict setObject:self.searchModel.maxAge forKey:@"AgeMax"];
  
  if (self.searchModel.Latitude != nil && self.searchModel.Longitude) {
    [mutDict setObject:self.searchModel.Latitude forKey:@"Latitude"];
    [mutDict setObject:self.searchModel.Longitude forKey:@"Longitude"];
  }
  
  
  [mutDict setObject:self.searchMatchType == MaxSearchType ? @(1) : @(0) forKey:@"MatchMax"];
  
  [self.searchModel.preferencesArray removeAllObjects];
  [self.searchModel.preferencesArray addObjectsFromArray:self.associationModel.addedCirclesArray];
  
  
  if (self.searchModel.preferencesArray.count > 0) {
    NSString *preferenceString = [self preparePreferencesMutableStringByArray:self.searchModel.preferencesArray];
    [mutDict setObject:preferenceString forKey:@"PrivatePreferences"];
  } else {
    [mutDict setObject:@"" forKey:@"PrivatePreferences"];
  }
  
  [self.searchModel saveParamsWithSearchModel:self.searchModel];
  
  if (self.delegate != nil) {
    [self.delegate privateSearchByParams:mutDict];
  }
}

- (NSString *)preparePreferencesMutableStringByArray:(NSArray *)array {
  NSMutableString *mutString = [NSMutableString new];
  for (PreferencesMapping *mapping in array) {
    NSInteger index = [array indexOfObject:mapping];
    [mutString appendString:[mapping.IdPreferences stringValue]];
    if (index + 1 != array.count) {
      [mutString appendString:@","];
    }
  }
  
  return mutString;
}

- (IBAction)matchDidTap:(UIControl *)sender {
  self.searchMatchType = sender.tag;
  self.searchModel.searchType = @(self.searchMatchType);
  [self prepareMatchButtonsBySelected:self.searchMatchType];
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

