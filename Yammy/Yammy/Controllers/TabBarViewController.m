//
//  TabBarViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TabBarViewController.h"
#import "ChatViewController.h"
#import "NotificationsHelper.h"
#import "HDNotificationView.h"
#import "ProfileViewController.h"
#import "TabBarView.h"
#import "MyPublicProfileViewController.h"
#import "ActivityLineViewController.h"

@interface TabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.delegate = self;
  
  UINavigationController *navHomeVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Home" andStoryboardId:HOME_STORYBOARD_ID];
  navHomeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"home_page_tabbar_icon"] tag:HomeTabBarIndex];
  navHomeVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
  
  UINavigationController *navHotPageVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"HotPage" andStoryboardId:HOT_PAGE_STORYBOARD_ID];
  navHotPageVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"hot_page_tabbar_icon"] tag:HotPageTabBarIndex];
  navHotPageVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
  
  UINavigationController *navActivityLineVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ActivityLine" andStoryboardId:ACTIVITY_LINE_STORYBOARD_ID];
  navActivityLineVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"yammy_tabbar_icon"] tag:ActivityLineTabBarIndex];
  navActivityLineVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
  
  UINavigationController *navChatVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"ChatList" andStoryboardId:CHAT_LIST_STORYBOARD_ID];
  navChatVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"chat_tabbar_icon"] tag:ChatListTabBarIndex];
  navChatVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
  
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  navProfileVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"profile_tabbar_icon"] tag:MyProfileTabBarIndex];
  navProfileVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
  
  TabBarView *tabBarView = [TabBarView createTabBarView];
  self.tabBar.frame = tabBarView.frame;
  [self.tabBar insertSubview:tabBarView atIndex:HomeTabBarIndex];
  
  self.viewControllers = @[navHomeVC, navHotPageVC, navActivityLineVC, navChatVC, navProfileVC];
  
  [self setupReceiveNotification];
  
  self.selectedIndex = self.tabBarSelectIndex;
  
  [self loadBadges];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
  [self loadBadges];
}

- (void)loadBadges {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [[ServerManager sharedManager] getActivityLineStatsWithCompletion:^(ActivityLineStatsMapping *activityLineStatsMapping, NSString *errorMessage) {
      UITabBarItem *activityItem = [self.tabBar.items objectAtIndex:2];
      UITabBarItem *chatItem = [self.tabBar.items objectAtIndex:3];
      activityItem.badgeValue = [activityLineStatsMapping.All integerValue]  > 0 ? [NSString stringWithFormat:@"%ld", (long)[activityLineStatsMapping.All integerValue]] : nil;
      chatItem.badgeValue = [activityLineStatsMapping.Chats integerValue] > 0 ? [NSString stringWithFormat:@"%ld", (long)[activityLineStatsMapping.Chats integerValue]] : nil;
      
      [self prepareBadgePosition];
    }];
  });
}

- (void)prepareBadgePosition {
  for (UIView *tabBarButton in self.tabBar.subviews) {
    for (UIView *badgeView in tabBarButton.subviews) {
      NSString *className = NSStringFromClass([badgeView class]);
      if ([className rangeOfString:@"BadgeView"].location != NSNotFound) {
        badgeView.layer.transform = CATransform3DIdentity;
        badgeView.layer.transform = CATransform3DMakeTranslation(-2.0, -8.0, 1.0);
      }
    }
  }
}

- (void)setupReceiveNotification {
  //    if (DELEGATE.notification != nil) {
  //        [self prepareNotificationByDictionary:DELEGATE.notification];
  //    }
  
  [[NSNotificationCenter defaultCenter] addObserverForName:RECEIVE_PUSH object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    NSDictionary *dict = [note userInfo];
    [self prepareNotificationByDictionary:dict];
    [self loadBadges];
  }];
}

- (void)prepareNotificationByDictionary:(NSDictionary *)dict {
  ActivityLineMapping *mapping = [self getActivityLineMappingByData:dict];
  if ([ServerManager sharedManager].myProfileMapping == nil) {
    [[ServerManager sharedManager] getProfileById:nil withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
      if (profileMapping) {
        [ServerManager sharedManager].myProfileMapping = profileMapping;
      }
      [self prepareNotificationByActivityLineMapping:mapping];
    }];
  } else {
    [self prepareNotificationByActivityLineMapping:mapping];
  }
}

- (void)prepareNotificationByActivityLineMapping:(ActivityLineMapping *)mapping {
  if (DELEGATE.isDidTapNotification == NO) {
    [HDNotificationView showNotificationViewWithImage:nil title:mapping.Title message:mapping.SubTitle isAutoHide:YES onTouch:^{
      [HDNotificationView hideNotificationViewOnComplete:^{
        if ([mapping.EventType integerValue] == Chated) {
          ChatViewController *chatVC = (ChatViewController *)[(UINavigationController *)self.selectedViewController topViewController];
          if (![chatVC isKindOfClass:[ChatViewController class]]) {
            [self pushToChatVCByActivityLineMapping:mapping];
          }
        } else if ([mapping.EventType integerValue] == OpenedPrivateProfile ||
                   [mapping.EventType integerValue] ==  OpenedPrivateProfileForGift ||
                   [mapping.EventType integerValue] ==   RequestedPrivateProfile ||
                   [mapping.EventType integerValue] ==   RequestedPrivateProfileForGift ||
                   [mapping.EventType integerValue] == RejectedAccessToPrivateProfile ||
                   [mapping.EventType integerValue] == RejectedAccessForGiftToPrivateProfile ||
                   [mapping.EventType integerValue] == RequestedExchangePrivateProfile ||
                   [mapping.EventType integerValue] == RejectedExchangePrivateProfile ||
                   [mapping.EventType integerValue] == AcceptedExchangePrivateProfile) {
          [self setSelectedIndex:ActivityLineTabBarIndex];
        } else if ([mapping.EventType integerValue] == Gifted) {
          [self setSelectedIndex:MyProfileTabBarIndex];
          MyPublicProfileViewController *myProfile = (MyPublicProfileViewController *)[(UINavigationController *)self.selectedViewController topViewController];
          [myProfile presentMyGifts];
        } else if ([mapping.EventType integerValue] == Match || [mapping.EventType integerValue] == MatchByPrivatePreferences) {
          self.selectedIndex = ActivityLineTabBarIndex;
          [self setupActivityLineBySelectedIndex:2];
        } else if ([mapping.EventType integerValue] == Liked || [mapping.EventType integerValue] == SuperLiked) {
          self.selectedIndex = ActivityLineTabBarIndex;
          [self setupActivityLineBySelectedIndex:1];
        } else if ([mapping.EventType integerValue] == RejectedAccessToPrivateProfile) {
          self.selectedIndex = ActivityLineTabBarIndex;
        } else {
          [self pushToProfileVCByActivityLineMapping:mapping];
        }
      }];
    }];
  } else {
    if ([mapping.EventType integerValue] == Chated) {
      ChatViewController *chatVC = (ChatViewController *)[(UINavigationController *)self.selectedViewController topViewController];
      if ([chatVC isKindOfClass:[ChatViewController class]]) {
        if ([chatVC.profileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
          [self reloadChatTableViewByActivityLineMapping:mapping];
        } else {
          [[ServerManager sharedManager] getProfileById:mapping.FromUserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
            chatVC.profileMapping = profileMapping;
            [self reloadChatTableViewByActivityLineMapping:mapping];
          }];
        }
      } else {
        [self pushToChatVCByActivityLineMapping:mapping];
      }
    } else if ([mapping.EventType integerValue] == OpenedPrivateProfile ||
               [mapping.EventType integerValue] ==  OpenedPrivateProfileForGift ||
               [mapping.EventType integerValue] ==   RequestedPrivateProfile ||
               [mapping.EventType integerValue] ==   RequestedPrivateProfileForGift ||
               [mapping.EventType integerValue] == RejectedAccessToPrivateProfile ||
               [mapping.EventType integerValue] == RejectedAccessForGiftToPrivateProfile ||
               [mapping.EventType integerValue] == RequestedExchangePrivateProfile ||
               [mapping.EventType integerValue] == RejectedExchangePrivateProfile ||
               [mapping.EventType integerValue] == AcceptedExchangePrivateProfile) {
      [self setSelectedIndex:ActivityLineTabBarIndex];
    } else if ([mapping.EventType integerValue] == Gifted) {
      [self setSelectedIndex:MyProfileTabBarIndex];
      MyPublicProfileViewController *myProfile = (MyPublicProfileViewController *)[(UINavigationController *)self.selectedViewController topViewController];
      [myProfile presentMyGifts];
    } else if ([mapping.EventType integerValue] == Match || [mapping.EventType integerValue] == MatchByPrivatePreferences) {
      self.selectedIndex = ActivityLineTabBarIndex;
      [self setupActivityLineBySelectedIndex:2];
    } else if ([mapping.EventType integerValue] == Liked || [mapping.EventType integerValue] == SuperLiked) {
      self.selectedIndex = ActivityLineTabBarIndex;
      [self setupActivityLineBySelectedIndex:1];
    } else {
      [self pushToProfileVCByActivityLineMapping:mapping];
    }
  }
}

- (ActivityLineMapping *)getActivityLineMappingByData:(NSDictionary *)data {
  NSDictionary *mappingsDictionary = @{[NSNull null] : [ActivityLineMapping objectMapping]};
  RKMapperOperation *mapper = [[RKMapperOperation alloc] initWithRepresentation:data mappingsDictionary:mappingsDictionary];
  NSError *mappingError = nil;
  BOOL isMapped = [mapper execute:&mappingError];
  if (isMapped && !mappingError) { // parsed success
    ActivityLineMapping *activityLineMapping = [mapper.mappingResult.dictionary objectForKey:[NSNull null]];
    return activityLineMapping;
  }
  
  return nil;
}

- (UIApplicationState)applicationState {
  UIApplicationState state = [UIApplication sharedApplication].applicationState;
  return state;
}

- (void)reloadChatTableViewByActivityLineMapping:(ActivityLineMapping *)mapping {
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: mapping, @"activityEvent", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:NotificationActivityEventChated object:self userInfo:options];
}

- (ProfileMapping *)createProfileMappingByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  ProfileMapping *profileMapping = [ProfileMapping new];
  profileMapping.UserId = activityLineMapping.FromUserId;
  return profileMapping;
}

- (void)pushToChatVCByActivityLineMapping:(ActivityLineMapping *)mapping {
  if (mapping.FromUserId != nil) {
    [[ServerManager sharedManager] getProfileById:mapping.FromUserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
      UINavigationController *navChatVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
      ChatViewController *chatVC = (ChatViewController *)[navChatVC topViewController];
      
      if (profileMapping) {
        chatVC.profileMapping = profileMapping;
      } else {
        chatVC.profileMapping = [self createProfileMappingByActivityLineMapping:mapping];
      }
      
      [(UINavigationController *)self.selectedViewController pushViewController:chatVC animated:YES];
    }];
  }
}

- (void)pushToProfileVCByActivityLineMapping:(ActivityLineMapping *)mapping {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = [self createProfileMappingByActivityLineMapping:mapping];
  profileVC.isShowProfile = YES;
  [(UINavigationController *)self.selectedViewController pushViewController:profileVC animated:YES];
}

- (void)setupActivityLineBySelectedIndex:(NSInteger)index {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    ActivityLineViewController *activityLineViewController = (ActivityLineViewController *)[(UINavigationController *)self.selectedViewController topViewController];
    activityLineViewController.currentIndex = index;
    [activityLineViewController setSelectedPageIndex:activityLineViewController.currentIndex animated:NO];
    [activityLineViewController viewWillAppear:YES];
  });
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

