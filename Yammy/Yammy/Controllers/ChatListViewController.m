//
//  ChatListViewController.m
//  Yammy
//
//  Created by Alex on 06.10.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListTableViewCell.h"
#import "AllActivityTableSectionView.h"
#import "ChatViewController.h"
#import "NSDate+Utilities.h"
#import "NotificationsHelper.h"
#import "ChatMapping.h"
#import "YaMaxView.h"
#import "DirectConnectionClient.h"
#import "ProfileViewController.h"
#import "ServicesViewController.h"

@interface ChatListViewController ()<UITableViewDelegate, UITableViewDataSource, YaMaxViewDelegate, ServicesViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *chatsArray;

@property (strong, nonatomic) YaMaxView *yaMaxView;

@end

@implementation ChatListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.navigationItem.title = @"Чат";
  [self setupTableViewCells];
  
  self.tableView.layer.cornerRadius = 20.0;
  self.tableView.clipsToBounds = YES;
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataInBackground) name:UIApplicationWillEnterForegroundNotification object:[UIApplication sharedApplication]];
  
  [Helpers prepareStatusBarWithColor:RGB(249, 0, 64)];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:RGB(249, 0, 64)];
  
  // При появлении окна - Подписались на локальные уведомления , о новых чатах
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationActivityEventChated:) name:NotificationActivityEventChated object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // При появлении окна - обновили список чатов
  [self loadDataFromServer];
  // присоединились к вебсокетам
  [[DirectConnectionClient shared] connect];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  // При уходе из окна - отписываемся от локальных пушек
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationActivityEventChated object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)onNotificationActivityEventChated:(NSNotification *)notification {
  // При событии новое сообщение - обновить спсиок чатов
  [self loadDataFromServer];
  
  [(TabBarViewController *)DELEGATE.window.rootViewController loadBadges];
}

- (void)loadDataInBackground {
  [self loadDataFromServer];
}

#pragma mark - Private

- (void)setupYaMaxView {
  if (self.yaMaxView != nil) {
    [Helpers dismissCustomView:self.yaMaxView];
  }
  
  self.yaMaxView = [YaMaxView createYaMaxView];
  self.yaMaxView.delegate = self;
  [self.yaMaxView.layer addAnimation:[Helpers setupAnimation] forKey:kCATransition];
  [self.view addSubview:self.yaMaxView];
}

- (void)dismissYaMaxView {
  
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Services" andStoryboardId:SERVICES_STORYBOARD_ID];
  ServicesViewController *servicesVC = (ServicesViewController *)[navVC topViewController];
  servicesVC.delegate = self;
  [self.navigationController pushViewController:servicesVC animated:YES];

  [Helpers dismissCustomView:self.yaMaxView];
}

- (void)loadDataFromServer {
  [Helpers showSpinner];
  [[ServerManager sharedManager] getChatsListWithCompletion:^(NSArray *chatsArray, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (chatsArray) {
      self.chatsArray = chatsArray;
      [self.tableView reloadData];
      if (self.chatsArray.count == 0) {
        if ([GLobalRealReachability currentReachabilityStatus] == RealStatusViaWWAN || [GLobalRealReachability currentReachabilityStatus] == RealStatusViaWiFi) {
          [self setupYaMaxView];
        }
      } else {
        if (self.yaMaxView != nil) {
          [Helpers dismissCustomView:self.yaMaxView];
        }
      }
    }
  }];
}

- (void)setupTableViewCells {
  [self.tableView registerNib:[UINib nibWithNibName:@"ChatListTableViewCellOne" bundle:nil] forCellReuseIdentifier:kChatListCellOneIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"ChatListTableViewCellOneToOne" bundle:nil] forCellReuseIdentifier:kChatListCellOneToOneIdentifier];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.chatsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  ChatListMapping *chatListMapping = [self.chatsArray objectAtIndex:section];
  return chatListMapping.Items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ChatListTableViewCell *chatListCell = nil;
  
  ChatListMapping *chatListMapping = [self.chatsArray objectAtIndex:indexPath.section];
  ChatMapping *chatMapping = [chatListMapping.Items objectAtIndex:indexPath.row];
  
  if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] != [chatMapping.WithUserId integerValue]) {
    chatListCell = [tableView dequeueReusableCellWithIdentifier:kChatListCellOneToOneIdentifier];
    [chatListCell prepareToMessageByChatMapping:chatMapping];
  } else {
    chatListCell = [tableView dequeueReusableCellWithIdentifier:kChatListCellOneIdentifier];
    [chatListCell prepareFromMessageByChatMapping:chatMapping];
  }
  
  chatListCell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Удалить" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
    [self cleanChatByCell:cell];
    return YES;
  }]];
  
  chatListCell.rightSwipeSettings.transition = MGSwipeTransitionDrag;
  
  return chatListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  ChatListMapping *mapping = [self.chatsArray objectAtIndex:indexPath.section];
  ChatMapping *chatMapping = [mapping.Items objectAtIndex:indexPath.row];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] getProfileById:chatMapping.WithUserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
    [Helpers hideSpinner];
    UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Chat" andStoryboardId:CHAT_STORYBOARD_ID];
    ChatViewController *chatVC = (ChatViewController *)[navVC topViewController];
    chatVC.profileMapping = profileMapping;
    [self.navigationController pushViewController:chatVC animated:YES];
  }];
}

- (void)cleanChatByCell:(MGSwipeTableCell *)cell {
  NSIndexPath *indexPathFromCell = [self.tableView indexPathForCell:cell];
  ChatListMapping *mapping = [self.chatsArray objectAtIndex:indexPathFromCell.section];
  ChatMapping *chatMapping = [mapping.Items objectAtIndex:indexPathFromCell.row];
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] cleanChatByUserId:chatMapping.WithUserId withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (status) {
      [self loadDataFromServer];
    }
  }];
  
}

- (void)reloadMyPublicProfileServices {
  // TODO:
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

