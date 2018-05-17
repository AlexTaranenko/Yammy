//
//  SearchPrivateRoundViewController.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SearchPrivateRoundViewController.h"
#import "SearchPrivateViewController.h"
#import "CornerView.h"
#import "AddedCirclesCollectionViewCell.h"
#import "CirclesCollectionViewCell.h"
#import "AssociationModel.h"
#import "PreferencesMapping.h"
#import "DragView.h"

typedef enum : NSUInteger {
  AddedCirclesCollectionViewTag = 10,
  CirclesCollectionView
} SearchPrivateCollectionViewTag;

@interface SearchPrivateRoundViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SearchPrivateViewControllerDelegate>

@property (weak, nonatomic) IBOutlet AutoCornerView *targetView;

@property (weak, nonatomic) IBOutlet UICollectionView *addedCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *circleCollectionView;

@property (strong, nonatomic) DragView *dragView;
@property (strong, nonatomic) PreferencesMapping *preferencesMapping;

@property (strong, nonatomic) AssociationModel *associationModel;

@property (assign, nonatomic) CGFloat heightCircle;
@property (assign, nonatomic) CGFloat heightAddedCircle;

@property (assign, nonatomic) BOOL dragEnabled;

@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation SearchPrivateRoundViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.dragEnabled = NO;
  self.associationModel = [[AssociationModel alloc] init];
  
  self.addedCollectionView.tag = AddedCirclesCollectionViewTag;
  
  [self setupTargetView];
  [self prepareBackBarButtonItem];
  
  if (self.privateProfileMapping != nil) {
    [self loadCirclesFromServerAndAddedCircles:self.privateProfileMapping.PrivatePreferences];
  } else {
    [self loadCirclesFromServerAndAddedCircles:self.searchPrivateModel.preferencesArray];
  }
  
  UILongPressGestureRecognizer *longCircleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleCircleDrag:)];
  longCircleGesture.minimumPressDuration = 0.1;
  [self.circleCollectionView addGestureRecognizer:longCircleGesture];
  
  UILongPressGestureRecognizer *longAddedCircleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleAddedCircleDrag:)];
  longAddedCircleGesture.minimumPressDuration = 0.1;
  [self.addedCollectionView addGestureRecognizer:longAddedCircleGesture];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self setupDragItem];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (self.searchPrivateModel != nil) {
    if ([self tabBarIsVisible]) {
      __weak typeof(self) weakSelf = self;
      [self setTabBarVisible:![self tabBarIsVisible] animated:YES completion:^(BOOL finished) {
        [weakSelf.tabBarController.tabBar setHidden:YES];
      }];
    }
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
  self.targetView.borderWidth = @(2);
  self.targetView.borderColor = [UIColor whiteColor];
  self.targetView.lineCap = kCALineCapSquare;
  self.targetView.lineDashPattern = @[@3, @5];
  self.targetView.backgroundColor = RGBA(214, 0, 65, 0);
}

- (void)setupDragItem {
  self.dragView = [[DragView alloc] initWithFrame:CGRectMake(0, 0, self.heightCircle, self.heightCircle)];
  [self updateDragViewFrameIsAddedCircle:NO];
  self.dragView.clipsToBounds = YES;
  self.dragView.contentMode = UIViewContentModeScaleAspectFit;
  self.dragView.alpha = 0.0;
}

- (void)updateDragViewFrameIsAddedCircle:(BOOL)isAddedCircle {
  self.dragView.frame = CGRectMake(0, 0, isAddedCircle ? self.heightAddedCircle : self.heightCircle, isAddedCircle ? self.heightAddedCircle : self.heightCircle);
  self.dragView.layer.cornerRadius = self.dragView.frame.size.height / 2.f;
}

- (void)reloadCollectionViewsAfterUpdateByArray:(NSArray *)array {
  [self.associationModel prepareAddedCirclesArrayByArray:array];
  [self.associationModel filteredCirclesArray];
  [self.circleCollectionView reloadData];
  [self.addedCollectionView reloadData];
}

#pragma mark - Collection View

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightCell = 0;
  if (collectionView.tag == AddedCirclesCollectionViewTag) {
    heightCell = collectionView.frame.size.height - 10;
    if (self.heightAddedCircle == 0) {
      self.heightAddedCircle = heightCell;
    }
    heightCell = self.heightAddedCircle;
  } else {
    heightCell = (collectionView.frame.size.height) / 3.f - 30;
    if (self.heightCircle == 0) {
      self.heightCircle = heightCell;
    }
    heightCell = self.heightCircle;
  }
  
  return CGSizeMake(heightCell, heightCell);
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

#pragma mark - Action

- (void)backButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)successDidTap:(UIButton *)sender {
  if (self.privateProfileMapping != nil) {
    if (self.delegate != nil) {
      [self.delegate updatePreferencesAtThePrivateProfileByAddedPreferencesArray:self.associationModel.addedCirclesArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
  } else {
    [self.searchPrivateModel.preferencesArray removeAllObjects];
    [self.searchPrivateModel.preferencesArray addObjectsFromArray:self.associationModel.addedCirclesArray];
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"SearchPrivate" andStoryboardId:SEARCH_PRIVATE_STORYBOARD_ID];
    SearchPrivateViewController *searchPrivateVC = (SearchPrivateViewController *)[navVC topViewController];
    searchPrivateVC.delegate = self;
    searchPrivateVC.searchPrivateModel = self.searchPrivateModel;
    [self.navigationController pushViewController:searchPrivateVC animated:YES];
  }
}

#pragma mark - Delegate

- (void)privateSearchByParams:(NSDictionary *)params {
  if (self.delegate != nil) {
    [self.delegate searchProfilesWithParams:params];
  }
}

#pragma mark - Handle Added Circle

- (void)handleAddedCircleDrag:(UILongPressGestureRecognizer *)pan {
  if (pan.state == UIGestureRecognizerStateBegan) {
    [self addedCircleDragBeganByGesture:pan];
  } else if (pan.state == UIGestureRecognizerStateEnded) {
    if (self.dragEnabled == YES) {
      self.dragEnabled = NO;
      
      CGPoint point = [pan locationInView:self.circleCollectionView];
      self.dragView.center = point;
      if ([self isValidDragPoint:point]) {
        [self setupAddCircleToMoreCircles];
      } else {
        [self addedCircleEndDrag];
      }
    }
  } else if (self.dragEnabled == YES) {
    self.dragView.center = [pan locationInView:self.view];
  }
}

- (void)addedCircleDragBeganByGesture:(UILongPressGestureRecognizer *)pan {
  if (self.selectedIndexPath == nil) {
    CGPoint touch = [pan locationInView:self.addedCollectionView];
    NSIndexPath *indexPath = [self.addedCollectionView indexPathForItemAtPoint:touch];
    self.selectedIndexPath = indexPath;
    
    if (indexPath != nil) {
      [self updateDragViewFrameIsAddedCircle:YES];
      
      [self showDragViewByArray:self.associationModel.addedCirclesArray withGesture:pan andIndexPath:indexPath];
      
      [self.addedCollectionView performBatchUpdates:^{
        [self.associationModel.addedCirclesArray removeObjectAtIndex:indexPath.row];
        [self.addedCollectionView deleteItemsAtIndexPaths:@[indexPath]];
      } completion:nil];
      
      self.dragEnabled = YES;
      self.addedCollectionView.userInteractionEnabled = NO;
    }
  }
}

- (BOOL)isValidDragPoint:(CGPoint)point {
  return point.y > 0;
}

- (void)addedCircleEndDrag {
  [UIView animateWithDuration:0.2 animations:^{
    
  } completion:^(BOOL finished) {
    [self.addedCollectionView performBatchUpdates:^{
      [self.associationModel.addedCirclesArray insertObject:self.preferencesMapping atIndex:self.selectedIndexPath.row];
      [self.addedCollectionView insertItemsAtIndexPaths:@[self.selectedIndexPath]];
    } completion:^(BOOL finished) {
      if (self.selectedIndexPath.item == (self.associationModel.addedCirclesArray.count - 1)) {
        [self.addedCollectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
      }
      
      [self resetPropertiesIsAddedCircle:YES];
    }];
  }];
}

- (void)setupAddCircleToMoreCircles {
  self.dragView.alpha = 0.0;
  [self.associationModel.circlesArray addObject:self.preferencesMapping];
  [self.circleCollectionView reloadData];
  [self resetPropertiesIsAddedCircle:YES];
}

- (AddedCirclesCollectionViewCell *)selectedAddedCircleCellByIndexPath:(NSIndexPath *)indexPath {
  AddedCirclesCollectionViewCell *selectedAddedCircleCell = (AddedCirclesCollectionViewCell *)[self.addedCollectionView cellForItemAtIndexPath:indexPath];
  return selectedAddedCircleCell;
}


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

- (CirclesCollectionViewCell *)selectedCellByIndexPath:(NSIndexPath *)indexPath {
  CirclesCollectionViewCell *selectedCell = (CirclesCollectionViewCell *)[self.circleCollectionView cellForItemAtIndexPath:indexPath];
  return selectedCell;
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
}

- (void)showDragViewByArray:(NSArray *)array withGesture:(UILongPressGestureRecognizer *)pan andIndexPath:(NSIndexPath *)indexPath {
  self.preferencesMapping = [array objectAtIndex:indexPath.row];
  self.dragView.preferencesMapping = self.preferencesMapping;
  [self.view addSubview:self.dragView];
  self.dragView.center = [pan locationInView:self.view];
  self.dragView.alpha = 1.0;
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

