//
//  AllActivityViewController.m
//  Yammy
//
//  Created by Alex on 10/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//


#import "AllPhotoTableViewCell.h"
#import "AllActivityTableSectionView.h"
#import "AllLikeTableViewCell.h"
#import "AllMessageTableViewCell.h"
#import "AllShowProfileTableViewCell.h"
#import "AllOpenProfileTableViewCell.h"
#import "AllInvisibleTableViewCell.h"
#import "AllMoreTableViewCell.h"
#import "AllCoincidenceTableViewCell.h"
#import "AllGiftTableViewCell.h"
#import "AllSendedGiftTableViewCell.h"
#import "UIViewController+ActivityLine.h"
#import "MatchTableViewCell.h"
#import "ProfileViewController.h"
#import "ChatViewController.h"
#import "AllRequestProfileTableViewCell.h"
#import "GiftsViewController.h"
#import "PrivateProfileViewController.h"
#import "RequestShowPrivateProfileView.h"
#import "RequestGiftPrivateProfileView.h"

@interface AllActivityViewController : UIViewController

- (void)loadMoreActivityLinesByIsTopScroll:(BOOL)isTopScroll;

@end
@interface AllActivityViewController ()<UITableViewDataSource, UITableViewDelegate, AllCoincidenceTableViewCellDelegate, MatchTableViewCellDelegate, AllRequestProfileTableViewCellDelegate, GiftsViewControllerDelegate, AllOpenProfileTableViewCellDelegate, AllSendedGiftTableViewCellDelegate, AllInvisibleTableViewCellDelegate, RequestShowPrivateProfileViewDelegate, RequestGiftPrivateProfileViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *activityLinesArray;

@property (strong, nonatomic) RequestShowPrivateProfileView *requestShowPrivateProfileView;

@property (strong, nonatomic) RequestGiftPrivateProfileView *requestGiftPrivateProfileView;

@property (strong, nonatomic) ProfileMapping *selectProfileMapping;

@end

@implementation AllActivityViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self setupTableView];
  
  [self setupRefreshControlsByTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self loadActivilyLinesFromServer];
}

#pragma mark - Private

- (void)loadActivilyLinesFromServer {
  if (self.activityLinesArray.count == 0) {
    [Helpers showSpinner];
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
    
    if (self.activityLinesArray.count > 0) {
      ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray firstObject];
      if (activityLinesMapping != nil) {
        [mutDict setObject:activityLinesMapping.Group forKey:@"After"];
      }
    }
    
    [[ServerManager sharedManager] getActivityLinesWithParams:mutDict withCompletion:^(NSArray *activityLinesArray, NSString *errorMessage) {
      [Helpers hideSpinner];
      [self prepareActivityLinesByArray:activityLinesArray];
    }];
  }
}

- (void)prepareActivityLinesByArray:(NSArray *)array {
  
  if (array.count > 0) {
    for (ActivityLinesMapping *activityLinesMapping in array) {
      NSArray *filteredArray = [self.activityLinesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Group == %@", activityLinesMapping.Group]];
      if (filteredArray.count == 0) {
        [self.activityLinesArray addObject:activityLinesMapping];
      } else {
        ActivityLinesMapping *existing = [filteredArray firstObject];
        NSMutableArray *concatenated = [[NSMutableArray alloc] initWithArray:existing.Items];
        for (ActivityLineMapping *activityLineMapping in activityLinesMapping.Items) {
          if ([self checkItemInArray:concatenated andItem:activityLineMapping] == NO) {
            [concatenated addObject:activityLineMapping];
          }
        }
        
        existing.Items = [concatenated sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
          ActivityLineMapping *firstObj = (ActivityLineMapping *)obj1;
          ActivityLineMapping *secondObj = (ActivityLineMapping *)obj2;
          return [[NSDate dateWithTimeIntervalSince1970:[firstObj.EventDate doubleValue]] compare:[NSDate dateWithTimeIntervalSince1970:[secondObj.EventDate doubleValue]]] == NSOrderedAscending;
        }];
      }
    }
    
    //        [self.activityLinesArray sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"Group" ascending:NO]]];
    
    [self.activityLinesArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      ActivityLinesMapping *firstObj = (ActivityLinesMapping *)obj1;
      ActivityLinesMapping *secondObj = (ActivityLinesMapping *)obj2;
      return [[NSDate dateWithTimeIntervalSince1970:[firstObj.Group doubleValue]] compare:[NSDate dateWithTimeIntervalSince1970:[secondObj.Group doubleValue]]] == NSOrderedAscending;
    }];
    
    [self.tableView reloadData];
  }
}

- (BOOL)checkItemInArray:(NSArray *)items andItem:(ActivityLineMapping *)item {
  BOOL isCheck = NO;
  for (ActivityLineMapping *activityLineMapping in items) {
    if ([item.IdActivityLine isEqualToNumber:activityLineMapping.IdActivityLine]) {
      isCheck = YES;
      break;
    }
  }
  
  return isCheck;
}

- (void)setupTableView {
  [self.tableView registerNib:[UINib nibWithNibName:@"AllPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:kAllPhotoCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllLikeTableViewCell" bundle:nil] forCellReuseIdentifier:kAllLikeCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kAllMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllShowProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kAllShowProfileCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllOpenProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kAllOpenProfileCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllInvisibleTableViewCell" bundle:nil] forCellReuseIdentifier:kAllInvisibleCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllMoreTableViewCell" bundle:nil] forCellReuseIdentifier:kAllMoreCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllCoincidenceTableViewCellOne" bundle:nil] forCellReuseIdentifier:kAllCoincidenceCellOneIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllGiftTableViewCell" bundle:nil] forCellReuseIdentifier:kAllGiftCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllSendedGiftTableViewCell" bundle:nil] forCellReuseIdentifier:kAllSendedGiftCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"MatchTableViewCell" bundle:nil] forCellReuseIdentifier:kMatchCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"AllRequestProfileTableViewCell" bundle:nil] forCellReuseIdentifier:kAllRequestProfileCellIdentifier];
}

- (void)showRequestShowPrivateProfileView:(ActivityLineMapping *)activityLineMapping isRequest:(BOOL)isRequest {
  self.requestShowPrivateProfileView = [RequestShowPrivateProfileView createRequestShowPrivateProfileView];
  self.requestShowPrivateProfileView.delegate = self;
  self.requestShowPrivateProfileView.isRequest = isRequest;
  [self.requestShowPrivateProfileView prepareInterfaceByActivityLineMapping:activityLineMapping];
  [Helpers showCustomView:self.requestShowPrivateProfileView];
}

- (void)showRequestGiftPrivateProfileView:(ActivityLineMapping *)activityLineMapping {
  self.requestGiftPrivateProfileView = [RequestGiftPrivateProfileView createRequestGiftPrivateProfileView];
  self.requestGiftPrivateProfileView.delegate = self;
  [self.requestGiftPrivateProfileView prepareInterfaceByActivityLineMapping:activityLineMapping];
  [Helpers showCustomView:self.requestGiftPrivateProfileView];
}

#pragma mark - Public
BOOL _reachedEnd = NO;

- (void)loadMoreActivityLinesByIsTopScroll:(BOOL)isTopScroll {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  
  ActivityLinesMapping *activityLinesMapping = nil;
  if (isTopScroll) {
    activityLinesMapping = [self.activityLinesArray firstObject];
    if (activityLinesMapping != nil) {
      //            [mutDict setObject:activityLinesMapping.Group forKey:@"After"];
      ActivityLineMapping *newestItem = [[activityLinesMapping Items] firstObject];
      [mutDict setObject:[newestItem EventDate] forKey:@"After"];
    }
  } else {
    if(_reachedEnd)
    {
      [self.tableView.bottomRefreshControl endRefreshing];
      return;
    }
    activityLinesMapping = [self.activityLinesArray lastObject];
    if (activityLinesMapping != nil) {
      //            [mutDict setObject:activityLinesMapping.Group forKey:@"Before"];
      ActivityLineMapping *oldestItem = [[activityLinesMapping Items] lastObject];
      [mutDict setObject:[oldestItem EventDate] forKey:@"Before"];
    }
  }
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getActivityLinesWithParams:mutDict withCompletion:^(NSArray *activityLinesArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_STATS object:nil];
    if (activityLinesArray.count > 0) {
      [self prepareActivityLinesByArray:activityLinesArray];
    }
    else
    {
      if(!isTopScroll)
        _reachedEnd = YES;
    }
    
    
    if ([self.topRefreshControl isRefreshing] || [self.tableView.bottomRefreshControl isRefreshing]) {
      if (isTopScroll) {
        [self.topRefreshControl endRefreshing];
      } else {
        [self.tableView.bottomRefreshControl endRefreshing];
      }
    }
  }];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self tableViewCellHeightByIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self tableViewCellHeightByIndexPath:indexPath];
}

- (CGFloat)tableViewCellHeightByIndexPath:(NSIndexPath *)indexPath {
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  ActivityLineMapping *activityLineMapping = [activityLinesMapping.Items objectAtIndex:indexPath.row];
  if ([activityLineMapping.EventType integerValue] == ChatStatusChanged ||
      [activityLineMapping.EventType integerValue] == ChatStatusChangedToSeen ||
      [activityLineMapping.EventType integerValue] == ChatStatusChangedToDelivered ||
      [activityLineMapping.EventType integerValue] == UnknownType ||
      [activityLineMapping.EventType integerValue] == Chated ||
      [activityLineMapping.EventType integerValue] == VipSuperLiked ||
      [activityLineMapping.EventType integerValue] == RejectedAccessButGift) {
    return 0.f;
  }
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 77.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return 77.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  AllActivityTableSectionView *allActivityTableSectionView = [AllActivityTableSectionView setupAllActivityTableSectionView];
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:section];
  NSDate *dateRepresentingThisDay = [NSDate dateWithTimeIntervalSince1970:[activityLinesMapping.Group doubleValue]];
  NSString *title = [Helpers prepareDateFormatterByDate:dateRepresentingThisDay andDateFormat:@"dd MMMM yyyy"];
  [allActivityTableSectionView prepareTitleLabelByText:[NSString stringWithFormat:@"%@", title]];
  
  return allActivityTableSectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.activityLinesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:section];
  return activityLinesMapping.Items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  ActivityLineMapping *activityLineMapping = [activityLinesMapping.Items objectAtIndex:indexPath.row];
  
  switch ([activityLineMapping.EventType integerValue]) {
    case ProfileChanged:
      return [self prepareAllShowProfileCellByActivityLineMapping:activityLineMapping];
      break;

    case ProfileNewPhoto:
      return [self prepareAllPhotoCellByActivityLineMapping:activityLineMapping];
      break;

    case OpenedPrivateProfile:
      return [self prepareAllOpenProfileCellByActivityLineMapping:activityLineMapping];
      break;

    case OpenedPrivateProfileForGift:
      return [self prepareAllOpenProfileCellByActivityLineMapping:activityLineMapping];
      break;

    case RequestedPrivateProfile:
      return [self prepareAllOpenProfileCellByActivityLineMapping:activityLineMapping];
      break;

    case RequestedPrivateProfileForGift:
      return [self prepareAllGiftCellByActivityLineMapping:activityLineMapping];
      break;

    case VisitedProfile:
      return [self prepareAllShowProfileCellByActivityLineMapping:activityLineMapping];
      break;

    case InvisibleVisitedProfile:
      return [self prepareAllInvisibleCellByActivityLineMapping:activityLineMapping];
      break;

    case Gifted:
      return [self prepareAllSendedGiftCellByActivityLineMapping:activityLineMapping];
      break;

    case Match:
      return [self prepareMatchCellByActivityLineMapping:activityLineMapping];
      break;
  
    case MatchByPrivatePreferences:
      return [self prepareAllCoincidenceCellByActivityLineMapping:activityLineMapping];
      break;
  
    case Liked:
      return [self prepareAllLikeCellByActivityLineMapping:activityLineMapping];
      break;

    case SuperLiked:
      return [self prepareAllLikeCellByActivityLineMapping:activityLineMapping];
      break;

    case RejectedAccessToPrivateProfile:
      return [self prepareAllRequestProfileTableViewCellByActivityLineMapping:activityLineMapping];
      break;

    case RejectedAccessForGiftToPrivateProfile:
      return [self prepareAllRequestProfileTableViewCellByActivityLineMapping:activityLineMapping];
      break;

    case RequestedExchangePrivateProfile:
      return [self prepareAllRequestProfileTableViewCellByActivityLineMapping:activityLineMapping];
      break;

    case RejectedExchangePrivateProfile:
      return [self prepareAllRequestProfileTableViewCellByActivityLineMapping:activityLineMapping];
      break;

    case AcceptedExchangePrivateProfile:
      return [self prepareAllRequestProfileTableViewCellByActivityLineMapping:activityLineMapping];
      break;

    default:
      return [UITableViewCell new];
      break;
  }
}

- (AllShowProfileTableViewCell *)prepareAllShowProfileCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllShowProfileTableViewCell *allShowProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAllShowProfileCellIdentifier];
  [allShowProfileCell prepareAllShowProfileByActivityLineMapping:activityLineMapping];
  return allShowProfileCell;
}

- (AllPhotoTableViewCell *)prepareAllPhotoCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllPhotoTableViewCell *allPhotoCell = [self.tableView dequeueReusableCellWithIdentifier:kAllPhotoCellIdentifier];
  [allPhotoCell prepareAllPhotoCellByActivityLineMapping:activityLineMapping];
  return allPhotoCell;
}

- (AllInvisibleTableViewCell *)prepareAllInvisibleCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllInvisibleTableViewCell *allInvisibleCell = [self.tableView dequeueReusableCellWithIdentifier:kAllInvisibleCellIdentifier];
  allInvisibleCell.delegate = self;
  [allInvisibleCell prepareAllInvisibleCellByActivityLineMapping:activityLineMapping];
  return allInvisibleCell;
}

- (AllLikeTableViewCell *)prepareAllLikeCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllLikeTableViewCell *allLikeCell = [self.tableView dequeueReusableCellWithIdentifier:kAllLikeCellIdentifier];
  [allLikeCell prepareAllLikeByActivityLineMapping:activityLineMapping];
  return allLikeCell;
}

- (AllMessageTableViewCell *)prepareAllMessageCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllMessageTableViewCell *allMessageCell = [self.tableView dequeueReusableCellWithIdentifier:kAllMessageCellIdentifier];
  [allMessageCell prepareAllMessageCellByActivityLineMapping:activityLineMapping];
  return allMessageCell;
}

- (AllOpenProfileTableViewCell *)prepareAllOpenProfileCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllOpenProfileTableViewCell *allOpenProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAllOpenProfileCellIdentifier];
  allOpenProfileCell.delegate = self;
  [allOpenProfileCell prepareAllOpenProfileCellByActivityLineMapping:activityLineMapping];
  return allOpenProfileCell;
}

- (AllGiftTableViewCell *)prepareAllGiftCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllGiftTableViewCell *allGiftCell = [self.tableView dequeueReusableCellWithIdentifier:kAllGiftCellIdentifier];
  [allGiftCell prepareAllGiftCellByActivityLineMapping:activityLineMapping];
  return allGiftCell;
}

- (MatchTableViewCell *)prepareMatchCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  MatchTableViewCell *matchCell = [self.tableView dequeueReusableCellWithIdentifier:kMatchCellIdentifier];
  matchCell.delegate = self;
  [matchCell prepareMatchCellByActivityLineMapping:activityLineMapping];
  return matchCell;
}

- (AllCoincidenceTableViewCell *)prepareAllCoincidenceCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllCoincidenceTableViewCell *allCoincidenceCell = [self.tableView dequeueReusableCellWithIdentifier:kAllCoincidenceCellOneIdentifier];
  allCoincidenceCell.delegate = self;
  [allCoincidenceCell prepareAllCoincidenceCellByMatchMapping:activityLineMapping.Match];
  return allCoincidenceCell;
}

- (AllSendedGiftTableViewCell *)prepareAllSendedGiftCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllSendedGiftTableViewCell *allSendedGiftCell = [self.tableView dequeueReusableCellWithIdentifier:kAllSendedGiftCellIdentifier];
  allSendedGiftCell.delegate = self;
  [allSendedGiftCell prepareAllSendedGiftByActivityLineMapping:activityLineMapping];
  return allSendedGiftCell;
}

- (AllRequestProfileTableViewCell *)prepareAllRequestProfileTableViewCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  AllRequestProfileTableViewCell *allRequestProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kAllRequestProfileCellIdentifier];
  allRequestProfileCell.delegate = self;
  [allRequestProfileCell prepareAllRequestProfileByActivityLineMapping:activityLineMapping];
  return allRequestProfileCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  ActivityLineMapping *activityLineMapping = [activityLinesMapping.Items objectAtIndex:indexPath.row];
  
  switch ([activityLineMapping.EventType integerValue]) {
    case ProfileChanged: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case ProfileNewPhoto: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case RequestedPrivateProfile: [self showRequestShowPrivateProfileView:activityLineMapping isRequest:NO]; break;
      
    case RequestedPrivateProfileForGift: [self showRequestGiftPrivateProfileView:activityLineMapping]; break;
      
    case VisitedProfile: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case Liked: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case SuperLiked: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case Match: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case RejectedAccessToPrivateProfile: [self showRequestShowPrivateProfileView:activityLineMapping isRequest:YES]; break;
      
    case AcceptedExchangePrivateProfile: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
    case MatchByPrivatePreferences: [self presentProfileByProfileMapping:activityLineMapping.FromUser]; break;
      
//    case Chated: {
//      [self pushToChatByProfileMapping:activityLineMapping.FromUser];
//    } break;
      
    default:
      break;
  }
}

- (void)pushToChatByProfileMapping:(ProfileMapping *)profileMapping {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
  ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
  chatVC.profileMapping = profileMapping;
  [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - Delegate

- (void)openChatByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self presentPrivateProfileByMapping:activityLineMapping.FromUser];
//  [self pushToChatByProfileMapping:activityLineMapping.FromUser];
}

- (void)openMatchChatByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self pushToChatByProfileMapping:activityLineMapping.FromUser];
}

- (void)cancelRequest:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:NO withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self removeCellByCell:cell];
    }
  }];
}

- (void)showGifts:(UITableViewCell *)cell {
  [self presentGiftByCell:cell];
}

- (void)showChat:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self pushToChatByProfileMapping:activityLineMapping.FromUser];
}

- (void)acceptRequest:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:YES withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
//      [self removeCellByCell:cell];
    }
  }];
}

- (void)showProfile:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self presentProfileByProfileMapping:activityLineMapping.FromUser];
}

- (void)reloadGiftsAtTheProfile {
  [self loadActivilyLinesFromServer];
}

- (void)presentPrivateProfileByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self presentPrivateProfileByMapping:activityLineMapping.FromUser];
}

- (void)cancelOpenProfileByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:NO withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self removeCellByCell:cell];
    }
  }];
}

- (void)acceptOpenProfileByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:YES withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
//      [self removeCellByCell:cell];
    }
  }];
}

- (void)sendGiftByCell:(UITableViewCell *)cell {
  [self presentGiftByCell:cell];
}

- (void)openProfileAllSendedGiftByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self presentProfileByProfileMapping:activityLineMapping.FromUser];
}

- (void)presentGiftByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.delegate = self;
  giftsVC.profileMapping = activityLineMapping.FromUser;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)presentInvisiblePopup {
  [self presentMotivationByPage:InvisiblePage];
}

- (void)showGiftsScreen:(CustomButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  [self presentGiftsBySender:sender];
}

- (void)sendRequestProfile:(UIButton *)sender {
  if (self.requestShowPrivateProfileView.isRequest) {
    [Helpers dismissCustomView:self.requestShowPrivateProfileView];
    [self presentGiftsBySender:sender];
  } else {
    [Helpers dismissCustomView:self.requestShowPrivateProfileView];
    ActivityLineMapping *activityLineMapping = [self getActivityLineMappingBySender:sender];
    [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:YES withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
      if (status) {
        
      }
    }];
  }
}

- (void)cancelSendRequest:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestShowPrivateProfileView];
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingBySender:sender];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:NO withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self removeCellBySender:sender];
    }
  }];
}

- (void)presentGiftsBySender:(UIButton *)sender {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingBySender:sender];
  self.selectProfileMapping = activityLineMapping.FromUser;
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.delegate = self;
  giftsVC.profileMapping = nil;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)sendGiftBySelectGiftMapping:(GiftMapping *)giftMapping {
  if (self.selectProfileMapping != nil) {
    
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
    [mutDict setObject:self.selectProfileMapping.UserId forKey:@"UserId"];
    [mutDict setObject:@(1) forKey:@"Level"];
    
    if (giftMapping) {
      [mutDict setObject:giftMapping.IdGift forKey:@"GiftId"];
    }
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] requestPrivateProfileWithParams:mutDict withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [Helpers hideSpinner];
      self.selectProfileMapping = nil;
      if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 531) {
        [self presentMotivationByPage:YaMaxPage];
      } else if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] == 530) {
        [UIAlertHelper alert:responseStatusModel.localized title:responseStatusModel.errorMessage];
      } else {
        [WToast showWithText:@"Запрос отправлен"];
      }
    }];
  }
}

- (void)cancelRequestGift:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestGiftPrivateProfileView];
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingBySender:sender];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:NO withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self removeCellBySender:sender];
    }
  }];
}

- (void)acceptRequestGift:(UIButton *)sender {
  [Helpers dismissCustomView:self.requestGiftPrivateProfileView];
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingBySender:sender];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsForReplyRequestByIsAccept:YES withActivityLineMapping:activityLineMapping] withCompletin:^(BOOL status, NSString *errorMessage) {
    if (status) {
      
    }
  }];
}

- (void)openMatchPublicProfileByCell:(UITableViewCell *)cell {
  ActivityLineMapping *activityLineMapping = [self getActivityLineMappingByCell:cell];
  [self presentProfileByProfileMapping:activityLineMapping.FromUser];
}

- (NSIndexPath *)indexPathFromSender:(UIButton *)sender {
  CGPoint center = sender.center;
  CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
  return indexPath;
}

- (ActivityLineMapping *)getActivityLineMappingBySender:(UIButton *)sender {
  NSIndexPath *indexPath = [self indexPathFromSender:sender];
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  ActivityLineMapping *activityLineMapping = [activityLinesMapping.Items objectAtIndex:indexPath.row];
  return activityLineMapping;
}

- (void)removeCellBySender:(UIButton *)sender {
  NSIndexPath *indexPath = [self indexPathFromSender:sender];
  [self reloadTableViewAfterRemoveCellByIndexPath:indexPath];
}

- (void)removeCellByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  [self reloadTableViewAfterRemoveCellByIndexPath:indexPath];
}

- (void)reloadTableViewAfterRemoveCellByIndexPath:(NSIndexPath *)indexPath {
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  NSMutableArray *mutArray = [NSMutableArray arrayWithArray:activityLinesMapping.Items];
  [mutArray removeObjectAtIndex:indexPath.row];
  activityLinesMapping.Items = mutArray;
  [self.tableView reloadData];
}

- (ActivityLineMapping *)getActivityLineMappingByCell:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  ActivityLinesMapping *activityLinesMapping = [self.activityLinesArray objectAtIndex:indexPath.section];
  ActivityLineMapping *activityLineMapping = [activityLinesMapping.Items objectAtIndex:indexPath.row];
  return activityLineMapping;
}

- (NSDictionary *)paramsForReplyRequestByIsAccept:(BOOL)isAccept withActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  return @{@"Token" : [Helpers getAccessToken],
           @"ActivityId" : activityLineMapping.IdActivityLine,
           @"Answer" : @(isAccept)};
}

- (NSMutableArray *)activityLinesArray {
  if (_activityLinesArray == nil) {
    _activityLinesArray = [NSMutableArray new];
  }
  return _activityLinesArray;
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

