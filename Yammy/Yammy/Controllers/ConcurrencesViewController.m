//
//  ConcurrencesViewController.m
//  Yammy
//
//  Created by Alex on 06.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ConcurrencesViewController.h"
#import "AllPhotoTableViewCell.h"
#import "AllActivityTableSectionView.h"
#import "NSDate+Utilities.h"
#import "MatchMapping.h"
#import "UIViewController+ActivityLine.h"
#import "MatchTableViewCell.h"
#import "ChatViewController.h"
#import "AllCoincidenceTableViewCell.h"
#import "ActivityLineMapping.h"
#import "ProfileViewController.h"

@interface ConcurrencesViewController ()<UITableViewDelegate, UITableViewDataSource, MatchTableViewCellDelegate, AllCoincidenceTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *matchesArray;
@property (strong, nonatomic) NSMutableDictionary *matchesDictionary;
@property (strong, nonatomic) NSArray *sortedDays;

@end

@implementation ConcurrencesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self setupTableViewCells];
  
  [self setupRefreshControlsByTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self loadMatchesFromServer];
}

#pragma mark - Private

- (void)setupTableViewCells {
  [self.tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:kMatchCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllCoincidenceTableViewCellOne" bundle:nil] forCellReuseIdentifier:kAllCoincidenceCellOneIdentifier];
}

- (void)loadMatchesFromServer {
  if (self.matchesArray.count == 0) {
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
    
    if (self.sortedDays.count > 0) {
      NSDate *dateRepresentingThisDay = [self.sortedDays firstObject];
      if (dateRepresentingThisDay) {
        [mutDict setObject:@([dateRepresentingThisDay timeIntervalSince1970]) forKey:@"After"];
      }
    }
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] getMatchesWithParams:mutDict wihCompletion:^(NSArray *matchesArray, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (matchesArray) {
        [self prepareMatchesListScreenTableWithArray:matchesArray];
      }
    }];
  }
}

- (void)prepareMatchesListScreenTableWithArray:(NSArray*)array {
  NSArray *arrayFromArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    if ([(MatchMapping *)obj1 EventDate] && [(MatchMapping *)obj2 EventDate]) {
      NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[[(MatchMapping *)obj1 EventDate] doubleValue]];
      NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[[(MatchMapping *)obj2 EventDate] doubleValue]];
      return [firstDate compare:secondDate] == NSOrderedAscending;
    } else {
      return NSOrderedAscending;
    }
  }];
  
  for (MatchMapping *mapping in arrayFromArray) {
    NSArray *filteredArray = [self.matchesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdMatch == %@", mapping.IdMatch]];
    if (filteredArray.count == 0) {
      [self.matchesArray addObject:mapping];
    }
  }
  
  [self prepareTableViewByDateSections];
  [self.tableView reloadData];
}

- (void)prepareTableViewByDateSections {
  BOOL firstDayAdded = NO;
  int counter = 0;
  NSMutableArray *dates = [NSMutableArray array];
  for (MatchMapping *mapping in self.matchesArray) {
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
    for (MatchMapping *mapping in self.matchesArray) {
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mapping.EventDate doubleValue]];
      if (date) {
        if ([[NSDate dateNoTime:dateFrom] isEqualToDate:[NSDate dateNoTime:date]]) {
          [array addObject:mapping];
        }
      }
    }
    
    [self.matchesDictionary setObject:[array copy] forKey:[NSDate dateNoTime:dateFrom]];
    [array removeAllObjects];
  }
  
  NSArray *unsortedDays = [self.matchesDictionary allKeys];
  self.sortedDays = [unsortedDays sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    return [(NSDate *)obj1 compare:(NSDate *)obj2] == NSOrderedAscending;
  }];
}

- (NSArray *)eventsOnThisDayBySection:(NSInteger)section {
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
  NSArray *eventsOnThisDay = [self.matchesDictionary objectForKey:dateRepresentingThisDay];
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
  return self.matchesDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self eventsOnThisDayBySection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MatchMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  
  if ([mapping.EventTypeTyped integerValue] == MatchByPrivatePreferences) {
    return [self prepareAllCoincidenceCellByMatchMapping:mapping];
  } else {
    MatchTableViewCell *matchCell = [tableView dequeueReusableCellWithIdentifier:kMatchCellIdentifier];
    matchCell.delegate = self;
    
    [matchCell prepareMatchCellByMapping:mapping];
    return matchCell;
  }
}

- (AllCoincidenceTableViewCell *)prepareAllCoincidenceCellByMatchMapping:(MatchMapping *)matchMapping {
  AllCoincidenceTableViewCell *allCoincidenceCell = [self.tableView dequeueReusableCellWithIdentifier:kAllCoincidenceCellOneIdentifier];
  allCoincidenceCell.delegate = self;
  [allCoincidenceCell prepareAllCoincidenceCellByMatchMapping:matchMapping];
  return allCoincidenceCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MatchMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
    profileVC.profileMapping = mapping.ToUser;
  } else {
    profileVC.profileMapping = mapping.FromUser;
  }

  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

#pragma mark - Delegate

- (void)openChatByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  MatchMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
    [self presentProfileByProfileMapping:mapping.ToUser];
  } else {
    [self presentProfileByProfileMapping:mapping.FromUser];
  }

//  [self pushToChatByCell:cell];
}

- (void)openMatchChatByCell:(UITableViewCell *)cell {
  [self pushToChatByCell:cell];
}

- (void)openMatchPublicProfileByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  MatchMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
    [self presentProfileByProfileMapping:mapping.ToUser];
  } else {
    [self presentProfileByProfileMapping:mapping.FromUser];
  }
}

- (void)pushToChatByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  MatchMapping *mapping = [[self eventsOnThisDayBySection:indexPath.section] objectAtIndex:indexPath.row];
  
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
  ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
  
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
    chatVC.profileMapping = mapping.ToUser;
  } else {
    chatVC.profileMapping = mapping.FromUser;
  }
  
  [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - Public

- (void)loadMoreMatchesByIsTopScroll:(BOOL)isTopScroll {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  
  NSDate *dateRepresentingThisDay = nil;
  if (isTopScroll) {
    dateRepresentingThisDay = [self.sortedDays firstObject];
    NSArray *eventsOnThisDay = [self.matchesDictionary objectForKey:dateRepresentingThisDay];
    MatchMapping *mapping = [eventsOnThisDay firstObject];
    if (mapping.EventDate) {
      [mutDict setObject:mapping.EventDate forKey:@"After"];
    }
  } else {
    dateRepresentingThisDay = [self.sortedDays lastObject];
    NSArray *eventsOnThisDay = [self.matchesDictionary objectForKey:dateRepresentingThisDay];
    MatchMapping *mapping = [eventsOnThisDay lastObject];
    if (mapping.EventDate) {
      [mutDict setObject:mapping.EventDate forKey:@"Before"];
    }
  }
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getMatchesWithParams:mutDict wihCompletion:^(NSArray *matchesArray, NSString *errorMessage) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [Helpers hideSpinner];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_STATS object:nil];
      if (matchesArray.count > 0) {
        [self prepareMatchesListScreenTableWithArray:matchesArray];
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

- (NSMutableArray *)matchesArray {
  if (_matchesArray == nil) {
    _matchesArray = [NSMutableArray new];
  }
  return _matchesArray;
}

- (NSMutableDictionary *)matchesDictionary {
  if (_matchesDictionary == nil) {
    _matchesDictionary = [NSMutableDictionary new];
  }
  return _matchesDictionary;
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

