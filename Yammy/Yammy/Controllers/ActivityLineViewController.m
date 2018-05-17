//
//  ActivityLineViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ActivityLineViewController.h"
#import "AllActivityViewController.h"
#import "ActivityLineTitleView.h"
#import "LikesViewController.h"
#import "ConcurrencesViewController.h"
#import "ContactListViewController.h"
#import "ActivityLineStatsMapping.h"

@interface ActivityLineViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate, ActivityLineTitleViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (strong, nonatomic) IBOutletCollection(ActivityLineTitleView) NSArray *activityLineTitleArray;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (assign, nonatomic) CGFloat lastPosition;



@property (assign, nonatomic) NSInteger nextIndex;

@property (assign, nonatomic) BOOL userDraggingStartedTransitionInProgress;

@property (strong, nonatomic) NSMutableArray *pages;

@property (strong, nonatomic) NSArray *titlesArray;

@property (strong, nonatomic) ActivityLineStatsMapping *activityLineStatsMapping;

@end

@implementation ActivityLineViewController

- (NSMutableArray *)pages {
  if (!_pages)_pages = [NSMutableArray new];
  return _pages;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"События";
  
  self.titlesArray = @[@"Все", @"Лайки", @"Совпадения", @"Избранные"];
  
  [self prepareActivityLineTitlesArrayByMapping:self.activityLineStatsMapping andCurrent:self.currentIndex];
  
  [self setupPagesFromStoryboardNames:@[@{@"storyboardName" : @"AllActivity", @"storyboardId" : ALL_ACTIVITY_STORYBOARD_ID},
                                        @{@"storyboardName" : @"Likes", @"storyboardId" : LIKES_STORYBOARD_ID},
                                        @{@"storyboardName" : @"Concurrences", @"storyboardId" : CONCURRENCES_STORYBOARD_ID},
                                        @{@"storyboardName" : @"ContactList", @"storyboardId" : CONTACT_LIST_STORYBOARD_ID}]];
  
  [self preparePageViewController];
  
  if ([self.pages count] > 0) {
    [self setSelectedPageIndex:0 animated:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  
  [self loadActivityLineStatsWithIndex:self.currentIndex];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:UPDATE_STATS object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self loadActivityLineStatsWithIndex:self.currentIndex];
  }];
  
  [[NSNotificationCenter defaultCenter] addObserverForName:kRealReachabilityChangedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self loadActivityLineStatsWithIndex:self.currentIndex];
  }];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UPDATE_STATS object:nil];
}

- (void)loadActivityLineStatsWithIndex:(NSInteger)indexOfCurrent {
  if ([GLobalRealReachability currentReachabilityStatus] == RealStatusNotReachable || [GLobalRealReachability currentReachabilityStatus] == RealStatusUnknown) {
    //    [WToast showWithText:@"Не удалось загрузить данные, проверьте соединение."];
  } else {
    if (self.currentIndex + 1 != self.pages.count) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] getActivityLineStatsWithCompletion:^(ActivityLineStatsMapping *activityLineStatsMapping, NSString *errorMessage) {
        [Helpers hideSpinner];
        self.activityLineStatsMapping = activityLineStatsMapping;
        [self prepareActivityLineTitlesArrayByMapping:self.activityLineStatsMapping andCurrent:indexOfCurrent];
      }];
    }
    else
    {
      [self prepareActivityLineTitlesArrayByMapping:self.activityLineStatsMapping andCurrent:indexOfCurrent];
    }
  }
}

- (void)prepareActivityLineTitlesArrayByMapping:(ActivityLineStatsMapping *)activityLineStatsMapping andCurrent:(NSInteger)current {
  int index = 0;
  for (ActivityLineTitleView *activityLineTitleView in self.activityLineTitleArray) {
    NSString *title = [self.titlesArray objectAtIndex:index];
    activityLineTitleView.delegate = self;
    activityLineTitleView.buttonTag = index;
    activityLineTitleView.titleText = title;
    
    NSString *badgeNumberText = [self prepareBadgeNumberTextByTag:index andActivityLineStatsMapping:activityLineStatsMapping];
    if (badgeNumberText.length > 0) {
      activityLineTitleView.hidden = NO;
      activityLineTitleView.badgeNumberText = badgeNumberText;
    } else {
      activityLineTitleView.hidden = YES;
    }
    
    activityLineTitleView.bottomIndicatorColor = index == current ? RGB(214, 0, 65) : [UIColor clearColor];
    index += 1;
  }
}

- (NSString *)prepareBadgeNumberTextByTag:(int)buttonTag andActivityLineStatsMapping:(ActivityLineStatsMapping *)activityLineStatsMapping {
  switch (buttonTag) {
    case AllActivityButtonTag:
      return [activityLineStatsMapping.All integerValue] > 0 ? [activityLineStatsMapping.All stringValue] : @""; break;
      
    case LikesActivityButtonTag:
      return [activityLineStatsMapping.Likes integerValue] > 0 ? [activityLineStatsMapping.Likes stringValue] : @""; break;
      
    case MatchesActivityButtonTag:
      return [activityLineStatsMapping.Matches integerValue] > 0 ? [activityLineStatsMapping.Matches stringValue] : @""; break;
      
    default:
      return @""; break;
  }
}

- (void)preparePageViewController {
  self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
  self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
  [self.pageViewController setDataSource:self];
  [self.pageViewController setDelegate:self];
  [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
  [self addChildViewController:self.pageViewController];
  [self.contentContainer addSubview:self.pageViewController.view];
  
  for (UIView *view in self.pageViewController.view.subviews ) {
    if ([view isKindOfClass:[UIScrollView class]]) {
      ((UIScrollView *)view).delegate = self;
    }
  }
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
  if (index < [self.pages count]) {
    [self.pageViewController setViewControllers:@[self.pages[index]] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:NULL];
  }
}

- (void)setupPagesFromStoryboardNames:(NSArray *)storyboardNames {
  if (storyboardNames.count > 0) {
    for (NSDictionary *dictionary in storyboardNames) {
      NSString *storyboardName = [dictionary objectForKey:@"storyboardName"];
      NSString *storyboardId = [dictionary objectForKey:@"storyboardId"];
      UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:storyboardName andStoryboardId:storyboardId];
      UIViewController *viewController = (UIViewController *)[navVC topViewController];
      if (viewController) {
        [self.pages addObject:viewController];
      }
    }
  }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
  NSUInteger index = [self.pages indexOfObject:viewController];
  if ((index == NSNotFound) || (index == 0)) {
    return nil;
  }
  return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
  NSUInteger index = [self.pages indexOfObject:viewController];
  if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
    return nil;
  }
  return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers{
  self.nextIndex = [self.pages indexOfObject:[pendingViewControllers firstObject]];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  if(completed) {
    if (self.nextIndex != [self.pages indexOfObject:[previousViewControllers firstObject]]) {
      self.currentIndex = [self.pages indexOfObject:[pageViewController.viewControllers objectAtIndex:0]];
    }
  }
  
  self.nextIndex = self.currentIndex;
  [self loadActivityLineStatsWithIndex:self.currentIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.isTracking || scrollView.isDecelerating) {
    self.userDraggingStartedTransitionInProgress = YES;
  }
  
  if (self.nextIndex > self.currentIndex) {
    if (scrollView.contentOffset.x < (self.lastPosition - (.9 * scrollView.bounds.size.width))) {
      self.currentIndex = self.nextIndex;
    }
  } else {
    if (scrollView.contentOffset.x > (self.lastPosition + (.9 * scrollView.bounds.size.width))) {
      self.currentIndex = self.nextIndex;
    }
  }
  
  self.lastPosition = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  self.userDraggingStartedTransitionInProgress = NO;
}

- (void)selectActivityLineTitleByTag:(NSInteger)buttonTag {
  
  if (buttonTag >= self.pages.count) {
    return;
  }
  
  UIViewController *vc = [self.pages objectAtIndex:buttonTag];
  NSInteger index = [self.pages indexOfObject:vc];
  //  if (self.currentIndex == index) {
  //    return;
  //  }
  
  if (index > self.currentIndex) {
    [self.pageViewController setViewControllers:@[self.pages[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
  } else {
    [self.pageViewController setViewControllers:@[self.pages[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:NULL];
  }
  
  self.currentIndex = index;
  [self loadActivityLineStatsWithIndex:self.currentIndex];
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

