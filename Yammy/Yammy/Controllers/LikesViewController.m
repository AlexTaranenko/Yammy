//
//  LikesViewController.m
//  Yammy
//
//  Created by Alex on 06.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LikesViewController.h"
#import "AllLikeTableViewCell.h"
#import "AllActivityTableSectionView.h"
#import "LikeMapping.h"
#import "UIViewController+ActivityLine.h"
#import "ProfileViewController.h"

@interface LikesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *likesArray;
@property (strong, nonatomic) NSMutableDictionary *likesDictionary;
@property (strong, nonatomic) NSArray *sortedDays;

@end

@implementation LikesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self.tableView registerNib:[UINib nibWithNibName:@"AllLikeTableViewCell" bundle:nil] forCellReuseIdentifier:kAllLikeCellIdentifier];
  
  [self setupRefreshControlsByTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self loadLikesFromServer];
}

#pragma mark - Private

- (void)loadLikesFromServer {
  if (self.likesArray.count == 0) {
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
    
    if (self.sortedDays.count > 0) {
      NSDate *dateRepresentingThisDay = [self.sortedDays firstObject];
      if (dateRepresentingThisDay) {
        [mutDict setObject:@([dateRepresentingThisDay timeIntervalSince1970]) forKey:@"After"];
      }
    }
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] getLikesListWithParams:mutDict withCompletion:^(NSArray *likesArray, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (likesArray) {
        [self prepareLikesListScreenTableWithArray:likesArray];
      }
    }];
  }
}

- (void)prepareLikesListScreenTableWithArray:(NSArray*)array {
  NSArray *arrayFromArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    if ([(LikeMapping *)obj1 EventDate] && [(LikeMapping *)obj2 EventDate]) {
      NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[[(LikeMapping *)obj1 EventDate] doubleValue]];
      NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[[(LikeMapping *)obj2 EventDate] doubleValue]];
      return [firstDate compare:secondDate] == NSOrderedAscending;
    } else {
      return NSOrderedAscending;
    }
  }];
  
  for (LikeMapping *mapping in arrayFromArray) {
    NSArray *filteredArray = [self.likesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdLike == %@", mapping.IdLike]];
    if (filteredArray.count == 0) {
      [self.likesArray addObject:mapping];
    }
  }
  
  [self prepareTableViewByDateSections];
  [self.tableView reloadData];
}

- (void)prepareTableViewByDateSections {
  BOOL firstDayAdded = NO;
  int counter = 0;
  NSMutableArray *dates = [NSMutableArray array];
  for (LikeMapping *mapping in self.likesArray) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mapping.EventDate doubleValue]];
    if (date) {
      if (!firstDayAdded) {
        [dates addObject:date];
        firstDayAdded = YES;
      }
      if (![[NSDate dateNoTime:(NSDate *)[dates objectAtIndex:counter]] isEqualToDate:[NSDate dateNoTime:date]]) {
        [dates addObject:date];
        counter ++;
      }
    }
  }
  
  NSMutableArray *array = [NSMutableArray array];
  for (NSDate  *dateFrom in dates) {
    for (LikeMapping *mapping in self.likesArray) {
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mapping.EventDate doubleValue]];
      if (date) {
        if ([[NSDate dateNoTime:dateFrom] isEqualToDate:[NSDate dateNoTime:date]]) {
          [array addObject:mapping];
        }
      }
    }
    
    [self.likesDictionary setObject:[array copy] forKey:[NSDate dateNoTime:dateFrom]];
    [array removeAllObjects];
  }
  
  NSArray *unsortedDays = [self.likesDictionary allKeys];
  self.sortedDays = [unsortedDays sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [(NSDate *)obj1 compare:(NSDate *)obj2] == NSOrderedAscending;
  }];
}

- (NSArray *)eventsOnThisDayBySection:(NSInteger)section {
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
  NSArray *eventsOnThisDay = [self.likesDictionary objectForKey:dateRepresentingThisDay];
  return eventsOnThisDay;
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 37.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return 37.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  AllActivityTableSectionView *allActivityTableSectionView = [AllActivityTableSectionView setupAllActivityTableSectionView];
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
  NSString *title = [Helpers prepareDateFormatterByDate:dateRepresentingThisDay andDateFormat:@"dd MMMM yyyy"];
  [allActivityTableSectionView prepareTitleLabelByText:[NSString stringWithFormat:@"%@г.", title]];
  return allActivityTableSectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.likesDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self eventsOnThisDayBySection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  AllLikeTableViewCell *allLikeCell = [tableView dequeueReusableCellWithIdentifier:kAllLikeCellIdentifier];
  LikeMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  [allLikeCell prepareAllLikeByMapping:mapping];
  return allLikeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  LikeMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  [self presentProfileByProfileMapping:mapping.FromUser];
}

#pragma mark - Public

- (void)loadMoreLikesByIsTopScroll:(BOOL)isTopScroll {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  
  NSDate *dateRepresentingThisDay = nil;
  if (isTopScroll) {
    dateRepresentingThisDay = [self.sortedDays firstObject];
    NSArray *eventsOnThisDay = [self.likesDictionary objectForKey:dateRepresentingThisDay];
    LikeMapping *mapping = [eventsOnThisDay firstObject];
    if (mapping.EventDate) {
      [mutDict setObject:mapping.EventDate forKey:@"After"];
    }
  } else {
    dateRepresentingThisDay = [self.sortedDays lastObject];
    NSArray *eventsOnThisDay = [self.likesDictionary objectForKey:dateRepresentingThisDay];
    LikeMapping *mapping = [eventsOnThisDay lastObject];
    if (mapping.EventDate) {
      [mutDict setObject:mapping.EventDate forKey:@"Before"];
    }
  }
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getLikesListWithParams:mutDict withCompletion:^(NSArray *likesArray, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Helpers hideSpinner];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_STATS object:nil];
      if (likesArray.count > 0) {
        [self prepareLikesListScreenTableWithArray:likesArray];
      }
      
      if (isTopScroll) {
        [self.topRefreshControl endRefreshing];
      } else {
        [self.tableView.bottomRefreshControl endRefreshing];
      }
    });
  }];
}

#pragma mark - Getters

- (NSMutableArray *)likesArray {
  if (_likesArray == nil) {
    _likesArray = [NSMutableArray new];
  }
  return _likesArray;
}

- (NSMutableDictionary *)likesDictionary {
  if (_likesDictionary == nil) {
    _likesDictionary = [NSMutableDictionary new];
  }
  return _likesDictionary;
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

