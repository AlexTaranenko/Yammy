//
//  ChatViewController.m
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatNavTitleView.h"
#import "AllActivityTableSectionView.h"
#import "SoundInputMessageTableViewCell.h"
#import "SoundOutputMessageTableViewCell.h"
#import "TextInputMessageTableViewCell.h"
#import "TextOutputMessageTableViewCell.h"
#import "AudioManager.h"
#import "GiftMessageTableViewCell.h"
#import "NSDate+Utilities.h"
#import "ImageOutputMessageTableViewCell.h"
#import "ImageInputMessageTableViewCell.h"
#import "GiftsViewController.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "NotificationsHelper.h"
#import "ISEmojiView.h"
#import "ChatListViewController.h"
#import "TabBarViewController.h"
#import "ProfileViewController.h"
#import "FullImageView.h"
#import "ChatSectionView.h"
#import "StickerMessageTableViewCell.h"
#import <WYPopoverController/WYPopoverController.h>
#import "RightMenuViewController.h"
#import "StickerView.h"
#import "StickerCollectionViewCell.h"
#import "UIImage+FixOrientation.h"

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, GiftsViewControllerDelegate, ISEmojiViewDelegate, GiftMessageTableViewCellDelegate, ImageInputMessageTableViewCellDelegate, ImageOutputMessageTableViewCellDelegate, FullImageViewDelegate, WYPopoverControllerDelegate, RightMenuViewControllerDelegate, StickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SoundOutputMessageTableViewCellDelegate, TextOutputMessageTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomToolbarLayout;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet CustomButton *soundButton;
@property (weak, nonatomic) IBOutlet UIView *containerKeyboardView;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIView *containerSecondsView;
@property (weak, nonatomic) IBOutlet UIButton *emojiButton;

@property (weak, nonatomic) IBOutlet UICollectionView *groupStickerCollectionView;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableDictionary *messagesDictionary;
@property (strong, nonatomic) NSArray *sortedDays;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) FullImageView *fullImageView;
@property (strong, nonatomic) WYPopoverController *popoverController;

@property (assign, nonatomic) BOOL isCancelRecord;
@property (strong, nonatomic) NSTimer *timerForLabel;
@property (assign, nonatomic) NSInteger seconds;
@property (strong, nonatomic) StickerView *stickerView;
@property (strong, nonatomic) NSArray *groupStickersArray;
@property (strong, nonatomic) DictionaryMapping *selectedGroupSticker;

@end

@implementation ChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self hiddenMessageButton:YES andSound:NO];
  [self changeAudioInterfaceIsBegin:NO];
  [self prepareBackBarButtonItem];
  [self setupTableViewCells];
  [self setupRefreshControl];
  [self setupSoundButton];
  
  if ([Helpers isShowChatTutorial] == NO) {
    [self presentTutorialScreenByType:ChatTutorialType];
  }
  
  self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [self.groupStickerCollectionView registerNib:[UINib nibWithNibName:@"StickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStickerCollectionCellIdentifier];
  
  [self hiddenKeyboardView:YES];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [[ServerManager sharedManager] getGroupStickersWithCompletion:^(NSArray *groupStickersArray, NSString *errorMessage) {
      self.groupStickersArray = groupStickersArray;
      self.selectedGroupSticker = (DictionaryMapping *)[self.groupStickersArray firstObject];
      [self.groupStickerCollectionView reloadData];
    }];
  });
  
  if (self.profileMapping != nil) {
    [self loadMessagesFromServerByIsNewMessage:NO andIsOldMessage:NO];
  }
  
  [self prepareRightButton];
  
  [ServerManager sharedManager].forbiddenBlock = ^(NSString *errorMessage) {
    [Helpers hideSpinner];
    [self presentPaymentAlertWithMessage:errorMessage];
  };
  
  [ServerManager sharedManager].chatMotivationBlock = ^(NSNumber *statusCode) {
    [self presentMotivationByPage:DialogsPage];
  };
  
  // Dodge Keyboard when text field is selected
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self prepareNavTitle];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationActivityEventChatStatusChangedToDelivered:) name:NotificationActivityEventChatStatusChangedToDelivered object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationActivityEventChatStatusChangedToSeen:) name:NotificationActivityEventChatStatusChangedToSeen object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationActivityEventChated:) name:NotificationActivityEventChated object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationActivityEventChatStatusChangedToDelivered object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationActivityEventChatStatusChangedToSeen object:nil];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationActivityEventChated object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [[AudioManager sharedManager] requestToMicrophone];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)onNotificationActivityEventChatStatusChangedToDelivered:(NSNotification *)notification {
  ActivityLineMapping *activityEvent = (ActivityLineMapping*)[notification.userInfo objectForKey:@"activityEvent"];
  NSArray<NSString*>* chatIds = [[activityEvent Ids] componentsSeparatedByString:@","];
  
  [self updatetableByChatsIds:chatIds andStatusMessage:STATUS_DELIVERED];
}

- (void)onNotificationActivityEventChatStatusChangedToSeen:(NSNotification *)notification {
  ActivityLineMapping *activityEvent = (ActivityLineMapping*)[notification.userInfo objectForKey:@"activityEvent"];
  NSArray<NSString*>* chatIds = [[activityEvent Ids] componentsSeparatedByString:@","];
  
  [self updatetableByChatsIds:chatIds andStatusMessage:STATUS_READ];
}

- (void)onNotificationActivityEventChated:(NSNotification *)notification {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    [self loadProfileFromServer];
  });
  
  [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
  
  [(TabBarViewController *)DELEGATE.window.rootViewController loadBadges];
}

#pragma mark - Private

- (void)loadProfileFromServer {
  [[ServerManager sharedManager] getProfileById:self.profileMapping.UserId withCompletion:^(ProfileMapping *profileMapping, NSString *errorMessage) {
    if (profileMapping) {
      self.profileMapping = profileMapping;
      [self prepareNavTitle];
    }
  }];
}

- (void)prepareRightButton {
  NSLayoutConstraint * heightConstraint = [self.rightMenuButton.heightAnchor constraintEqualToConstant:40];
  NSLayoutConstraint * widthConstraint = [self.rightMenuButton.widthAnchor constraintEqualToConstant:40];
  [widthConstraint setActive:YES];
  [heightConstraint setActive:YES];
}

- (void)hiddenKeyboardView:(BOOL)hide {
  self.containerKeyboardView.hidden = hide;
  if (hide) {
    if ([self.textField.inputView isKindOfClass:[StickerView class]]) {
      self.textField.inputView = nil;
    }
  }
}

- (void)hiddenMessageButton:(BOOL)isHiddenMessage andSound:(BOOL)isHiddenSound {
  self.soundButton.hidden = isHiddenSound;
  self.sendButton.hidden = isHiddenMessage;
}

- (void)setupSoundButton {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
  [self.soundButton addGestureRecognizer:longPress];
  
  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
  swipe.direction = UISwipeGestureRecognizerDirectionLeft;
  [self.soundButton addGestureRecognizer:swipe];
}

- (void)updatetableByChatsIds:(NSArray<NSString*> *)chatIds andStatusMessage:(NSInteger)status {
  for (NSString *idString in chatIds) {
    NSNumber *idNumber = [self prepareNumberFormatterByString:idString];
    
    for (NSDate *dateRepresentingThisDay in self.sortedDays) {
      NSArray *eventsOnThisDay = [self.messagesDictionary objectForKey:dateRepresentingThisDay];
      for (MessageMapping *mapping in eventsOnThisDay) {
        if ([idNumber integerValue] == [mapping.IdMessage integerValue]) {
          mapping.Status = @(status);
          break;
        }
      }
    }
  }
  
  [self.tableView reloadData];
}

- (void)prepareNavTitle {
  if (self.navigationItem.titleView != nil) {
    self.navigationItem.titleView = nil;
  }
  
  ChatNavTitleView *chatNavTitleView = [ChatNavTitleView createChatNavTitleView];
  [chatNavTitleView prepareChatNavTitleViewByProfileMapping:self.profileMapping];
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentProfileOpponent)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [chatNavTitleView addGestureRecognizer:tapGestureRecognizer];
  chatNavTitleView.userInteractionEnabled = YES;
  self.navigationItem.titleView = chatNavTitleView;
}

- (void)setupRefreshControl {
  self.refreshControl = [UIRefreshControl new];
  [self.refreshControl addTarget:self action:@selector(refreshTop) forControlEvents:UIControlEventValueChanged];
  [self.tableView addSubview:self.refreshControl];
}

- (void)loadMessagesFromServerByIsNewMessage:(BOOL)isNewMessage andIsOldMessage:(BOOL)isOldMessage {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  [mutDict setObject:self.profileMapping.UserId forKey:@"WithUserId"];
  
  MessageMapping *mapping = nil;
  if (isNewMessage) {
    mapping = [self.messages firstObject];
    if(mapping)
      [mutDict setObject:mapping.EventDate forKey:@"After"];
  } else if (isOldMessage) {
    
    mapping = [self.messages lastObject];
    if(mapping)
      [mutDict setObject:mapping.EventDate forKey:@"Before"];
  }
  
  [[ServerManager sharedManager] getMessagesWithParams:mutDict witnCompletion:^(NSArray *messagesArray, NSString *errorMessage) {
    [self prepareChatScreenTableWithArray:messagesArray];
    
    if ([self.tableView.bottomRefreshControl isRefreshing]) {
      [self.tableView.bottomRefreshControl endRefreshing];
    }
    
    if ([self.refreshControl isRefreshing]) {
      [self.refreshControl endRefreshing];
    }
  }];
}

- (void)setupTableViewCells {
  [self.tableView registerNib:[UINib nibWithNibName:@"SoundInputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kSoundInputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"SoundOutputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kSoundOutputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"TextInputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kTextInputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"TextOutputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kTextOutputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"GiftMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kGiftMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"ImageOutputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kImageOutputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"ImageInputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kImageInputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"StickerInputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kStickerInputMessageCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:@"StickerOutputMessageTableViewCell" bundle:nil] forCellReuseIdentifier:kStickerOutputMessageCellIdentifier];
}

- (void)presentGiftVC {
  UINavigationController *navVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Gifts" andStoryboardId:GIFTS_STORYBOARD_ID];
  GiftsViewController *giftsVC = (GiftsViewController *)[navVC topViewController];
  giftsVC.delegate = self;
  [self.navigationController pushViewController:giftsVC animated:YES];
}

- (void)sendMessageToFriendByMessageText:(NSString *)message {
  
  MessageMapping *messageMapping = [MessageMapping new];
  messageMapping.IdMessage = nil;
  messageMapping.Message = message;
  messageMapping.EventDate = @([[NSDate date] timeIntervalSince1970]);
  messageMapping.Status = @(STATUS_NEW);
  messageMapping.FromUserId = [ServerManager sharedManager].myProfileMapping.UserId;
  messageMapping.FromUser = [ServerManager sharedManager].myProfileMapping;
  messageMapping.ToUserId = self.profileMapping.UserId;
  messageMapping.ToUser = self.profileMapping;
  [self.messages addObject:messageMapping];
  [self prepareTableViewByDateSections];
  [self scrollToBottom];
  [self.tableView reloadData];
  
  [self sendMessageToServerByText:message];
}

- (void)sendMessageToServerByText:(NSString *)message {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"ToUserId" : self.profileMapping.UserId,
                           @"Message" : message
                           };
  
  [[ServerManager sharedManager] sendMessageWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    if (status) {
      self.textField.text = nil;
      [self checkSendButtonByText:self.textField.text];
      [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
    } else {
      MessageMapping *mapping = [self.messages lastObject];
      mapping.Status = @(STATUS_FAILED);
      [self.tableView reloadData];
      [UIAlertHelper alert:nil title:errorMessage];
    }
  }];
}

- (void)prepareChatScreenTableWithArray:(NSArray*)array {
  
  NSArray *arrayFromArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
    if ([(MessageMapping *)obj1 EventDate] && [(MessageMapping *)obj2 EventDate]) {
      NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:[[(MatchMapping *)obj1 EventDate] doubleValue]];
      NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:[[(MatchMapping *)obj2 EventDate] doubleValue]];
      return [firstDate compare:secondDate] == NSOrderedAscending;
    } else {
      return NSOrderedAscending;
    }
  }];
  
  for (MessageMapping *mapping in arrayFromArray) {
    NSArray *filteredArray = [self.messages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IdMessage == %@", mapping.IdMessage]];
    if (filteredArray.count == 0) {
      for (MessageMapping *mappingFromArray in self.messages) {
        if (([mappingFromArray.Message isEqualToString:mapping.Message] && [mappingFromArray.Status integerValue] == STATUS_NEW) || ([mappingFromArray.Message isEqualToString:mapping.Message] && [mappingFromArray.Status integerValue] == STATUS_FAILED)) {
          NSInteger index = [self.messages indexOfObject:mappingFromArray];
          [self.messages removeObjectAtIndex:index];
          break;
        }
      }
      
      [self.messages addObject:mapping];
    }
  }
  
  [self prepareTableViewByDateSections];
  [self.tableView reloadData];
  
  if ([self.refreshControl isRefreshing] == NO) {
    [self scrollToBottom];
  }
}

- (void)prepareTableViewByDateSections {
  BOOL firstDayAdded = NO;
  int counter = 0;
  NSMutableArray *dates = [NSMutableArray array];
  for (MessageMapping *mapping in self.messages) {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mapping.EventDate doubleValue]];
    if (!firstDayAdded) {
      [dates addObject:date];
      firstDayAdded = YES;
    }
    if (![[NSDate dateNoTime:(NSDate *)[dates objectAtIndex:counter]] isEqualToDate:[NSDate dateNoTime:date]]) {
      [dates addObject:date];
      counter ++;
    }
  }
  
  NSMutableArray *array = [NSMutableArray array];
  for (NSDate  *dateFrom in dates) {
    for (MessageMapping *mapping in self.messages) {
      NSDate *date = [NSDate dateWithTimeIntervalSince1970:[mapping.EventDate doubleValue]];
      if ([[NSDate dateNoTime:dateFrom] isEqualToDate:[NSDate dateNoTime:date]]) {
        [array addObject:mapping];
      }
    }
    
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
      return [[(MessageMapping *)obj1 EventDate] compare:[(MessageMapping *)obj2 EventDate]] == NSOrderedDescending;
    }];
    
    [self.messagesDictionary setObject:[array copy] forKey:[NSDate dateNoTime:dateFrom]];
    [array removeAllObjects];
  }
  
  NSArray *unsortedDays = [self.messagesDictionary allKeys];
  self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
}

- (void)scrollToBottom {
  NSInteger sections = [self.tableView numberOfSections];
  if (sections > 0) {
    NSInteger rows = [self.tableView numberOfRowsInSection:sections - 1];
    NSIndexPath *last = [NSIndexPath indexPathForRow:rows - 1 inSection:sections - 1];
    [self.tableView scrollToRowAtIndexPath:last atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

- (void)reloadChatByMapping:(MessageMapping *)mapping isDelete:(BOOL)delete {
  if (delete == NO) {
    [self.messages addObject:mapping];
  }
  [self prepareTableViewByDateSections];
  [self.tableView reloadData];
  [self scrollToBottom];
}

- (void)checkSendButtonByText:(NSString *)text {
  if (text.length > 0) {
    [self hiddenMessageButton:NO andSound:YES];
  } else {
    [self hiddenMessageButton:YES andSound:NO];
  }
}

- (void)changeEmojiButtonImage:(BOOL)isShowKeyboard {
  if (isShowKeyboard) {
    [self.emojiButton setImage:[UIImage imageNamed:@"keyboard_icon"] forState:UIControlStateNormal];
  } else {
    [self.emojiButton setImage:[UIImage imageNamed:@"chat_smile_button"] forState:UIControlStateNormal];
  }
}

- (void)presentPaymentAlertWithMessage:(NSString *)message {
  [UIAlertHelper alert:nil title:message cancelButton:@"Отмена" successButton:@"Пополнить" successCompletion:^(UIAlertAction *action) {
    [self presentServicesScreen];
  }];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.groupStickersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  StickerCollectionViewCell *stickerCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickerCollectionCellIdentifier forIndexPath:indexPath];
  DictionaryMapping *mapping = [self.groupStickersArray objectAtIndex:indexPath.row];
  [stickerCollectionCell prepareStickerCollectionCellByDictionaryMapping:mapping];
  return stickerCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(50.0, 50.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedGroupSticker = [self.groupStickersArray objectAtIndex:indexPath.row];
  [self.stickerView loadStickerFromServerByDictionary:self.selectedGroupSticker];
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.messagesDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
  NSArray *eventsOnThisDay = [self.messagesDictionary objectForKey:dateRepresentingThisDay];
  return eventsOnThisDay.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 21.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
  return 21.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  ChatSectionView *chatSectionView = [ChatSectionView setupChatSectionView];
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
  [chatSectionView prepareTimeLabelByDate:dateRepresentingThisDay];
  return chatSectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
  NSArray *eventsOnThisDay = [self.messagesDictionary objectForKey:dateRepresentingThisDay];
  MessageMapping *mapping = [eventsOnThisDay objectAtIndex:indexPath.row];
  
  if ([mapping.IsGift boolValue]) {
    GiftMessageTableViewCell *giftMessageCell = [tableView dequeueReusableCellWithIdentifier:kGiftMessageCellIdentifier];
    if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
      [giftMessageCell prepareGiftOutputMessageByMessageMapping:mapping];
    } else {
      giftMessageCell.delegate = self;
      [giftMessageCell prepareGiftMessageCellByMessageMapping:mapping];
    }
    return giftMessageCell;
  } else if (mapping.Image != nil) {
    if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
      ImageOutputMessageTableViewCell *imageOutputMessageCell = [tableView dequeueReusableCellWithIdentifier:kImageOutputMessageCellIdentifier];
      imageOutputMessageCell.delegate = self;
      [imageOutputMessageCell prepareImageOutputMessageByMessageMapping:mapping];
      return imageOutputMessageCell;
    } else {
      ImageInputMessageTableViewCell *imageInputMessageCell = [tableView dequeueReusableCellWithIdentifier:kImageInputMessageCellIdentifier];
      imageInputMessageCell.delegate = self;
      [imageInputMessageCell prepareImageInputMessageByMessageMapping:mapping];
      return imageInputMessageCell;
    }
  } else if (mapping.Audio != nil) {
    BOOL outgoing = [[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue];
    NSString *cellId = outgoing ? kSoundOutputMessageCellIdentifier : kSoundInputMessageCellIdentifier;
    SoundMessageTableViewCell *soundMessageTableViewCell = nil;
    
    if (outgoing) {
      SoundOutputMessageTableViewCell *soundOutputMessageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
      soundOutputMessageTableViewCell.delegate = self;
      [soundOutputMessageTableViewCell changeStatusImageByMessageMapping:mapping];
      soundMessageTableViewCell = soundOutputMessageTableViewCell;
    } else {
      SoundInputMessageTableViewCell *soundInputMessageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
      soundMessageTableViewCell = soundInputMessageTableViewCell;
    }
    
    [soundMessageTableViewCell prepareSoundMessageCellByMessageMapping:mapping isOutgoing:outgoing];
    return soundMessageTableViewCell;
  } else if (mapping.Sticker != nil) {
    BOOL outgoing = [[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue];
    NSString *cellId = outgoing ? kStickerOutputMessageCellIdentifier : kStickerInputMessageCellIdentifier;
    StickerMessageTableViewCell *stickerMessageTableViewCell = nil;
    
    if (outgoing) {
      StickerMessageTableViewCell *stickerOutputMessageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
      stickerMessageTableViewCell = stickerOutputMessageTableViewCell;
    } else {
      StickerMessageTableViewCell *stickerInputMessageTableViewCell = [tableView dequeueReusableCellWithIdentifier:cellId];
      stickerMessageTableViewCell = stickerInputMessageTableViewCell;
    }
    
    [stickerMessageTableViewCell prepareStickerMessageByMessageMapping:mapping];
    return stickerMessageTableViewCell;
  } else {
    if ([[ServerManager sharedManager].myProfileMapping.UserId integerValue] == [mapping.FromUserId integerValue]) {
      TextOutputMessageTableViewCell *textOutputMessageCell = [tableView dequeueReusableCellWithIdentifier:kTextOutputMessageCellIdentifier];
      textOutputMessageCell.delegate = self;
      [textOutputMessageCell prepareCellByMessageMapping:mapping];
      return textOutputMessageCell;
    } else {
      TextInputMessageTableViewCell *textInputMessageCell = [tableView dequeueReusableCellWithIdentifier:kTextInputMessageCellIdentifier];
      [textInputMessageCell prepareCellByMessageMapping:mapping];
      return textInputMessageCell;
    }
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if ([scrollView isKindOfClass:[UITableView class]]) {
    [self hiddenKeyboardView:YES];
  }
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
  NSDictionary *userInfo = [notification userInfo];
  CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat keyboardHeight = keyboardFrame.size.height;
  
  self.bottomToolbarLayout.constant = keyboardHeight - 49;
  [self.view setNeedsLayout];
}

- (void)keyboardDidShow:(NSNotification *)notification {
  [self scrollToBottom];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  self.bottomToolbarLayout.constant = 0;
  [self.view setNeedsLayout];
}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.view endEditing:YES];
  return YES;
}

- (IBAction)editingChangedTextField:(UITextField *)sender {
  [self checkSendButtonByText:sender.text];
}

#pragma mark - Actions

- (IBAction)leftSwipeDidTap:(UISwipeGestureRecognizer *)sender {
  [self returnToChatListController];
}

- (IBAction)keyboardDidTap:(UIButton *)sender {
  [self hiddenKeyboardView:YES];
  [self.textField becomeFirstResponder];
}

- (void)presentProfileOpponent {
  UINavigationController *navProfileVC = (UINavigationController *)[Helpers createCustomVCByStoryboardName:@"Profile" andStoryboardId:PROFILE_STORYBOARD_ID];
  ProfileViewController *profileVC = (ProfileViewController *)[navProfileVC topViewController];
  profileVC.profileMapping = self.profileMapping;
  profileVC.isShowProfile = YES;
  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)refreshTop {
  if ([self.refreshControl isRefreshing]) {
    [self loadMessagesFromServerByIsNewMessage:NO andIsOldMessage:YES];
  }
}

- (void)backButtonDidTap:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendDidTap:(UIButton *)sender {
  if (self.textField.text.length > 0) {
    [self sendMessageToFriendByMessageText:self.textField.text];
  }
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
  if ([[AudioManager sharedManager] checkPermision] == NO) {
    [[AudioManager sharedManager] presentAudioSettings];
  } else {
    if (gesture.state == UIGestureRecognizerStateChanged) {
      CGPoint coords = [gesture locationInView:gesture.view];
      if (coords.x <= -30) {
        self.isCancelRecord = YES;
        return;
      }
    } else if (gesture.state == UIGestureRecognizerStateBegan) {
      [Helpers startSoundIsEnd:NO];
      self.seconds = 0;
      self.secondsLabel.text = @"0";
      
      [self changeAudioInterfaceIsBegin:YES];
      
      if ([self.timerForLabel isValid]) {
        [self.timerForLabel invalidate];
      }
      
      self.timerForLabel = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[AudioManager sharedManager] beginRecordAudio];
      });
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
      
      if ([self.timerForLabel isValid]) {
        [self.timerForLabel invalidate];
      }
      
      self.seconds = 0;
      self.secondsLabel.text = @"0";
      
      [self changeAudioInterfaceIsBegin:NO];
      
      if (self.isCancelRecord) {
        [[AudioManager sharedManager] stopRecord];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          self.isCancelRecord = NO;
        });
      } else {
        [[AudioManager sharedManager] endRecordAudioWithCompletion:^(BOOL status, NSData *audioData, NSTimeInterval duration, NSString *errorMessage) {
          if (self.isCancelRecord == NO) {
            [Helpers startSoundIsEnd:YES];
            if(status) {
              NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
              [mutDict setObject:self.profileMapping.UserId forKey:@"ToUserId"];
              [mutDict setObject:@(duration) forKey:@"Duration"];
              
              [self checkSendButtonByText:nil];
              
              [[ServerManager sharedManager] sendAudioMessageWithParams:mutDict byFileData:audioData withCompletion:^(BOOL status, NSString *errorMessage) {
                if (status) {
                  [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
                } else {
                  [UIAlertHelper alert:nil title:errorMessage];
                }
              }];
            } else {
              // TODO: Show error
              NSLog(@"ERROR: %@", errorMessage);
            }
          } else {
            self.isCancelRecord = NO;
          }
        }];
      }
    }
  }
}

- (void)timerTick {
  self.seconds++;
  self.secondsLabel.text = [NSString stringWithFormat:@"%ld", (long)self.seconds];
}

- (void)changeAudioInterfaceIsBegin:(BOOL)isBegin {
  [self.soundButton setBackgroundColor:isBegin ? RGB(249, 0, 64) : [UIColor clearColor]];
  [self.soundButton setImage:[UIImage imageNamed:isBegin ? @"microphone_icon" : @"sound_message_icon"] forState:UIControlStateNormal];
  self.textField.placeholder = isBegin ? @"Смахните влево для отмены" : @"Введите сообщение";
  self.textField.textAlignment = isBegin ? NSTextAlignmentCenter : NSTextAlignmentLeft;
  self.containerSecondsView.hidden = isBegin ? NO : YES;
}

- (IBAction)rightMenuDidTap:(UIButton *)sender {
  [self presentPopoverByIsRightMenu:YES andSize:CGSizeMake(225, 148) andWYPopoverArrowDirection:WYPopoverArrowDirectionUp withSender:sender];
}

- (void)dismissPopoverView {
  [self.popoverController dismissPopoverAnimated:YES completion:^{
    [self popoverControllerDidDismissPopover:self.popoverController];
  }];
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
  self.popoverController = nil;
}

- (void)selectRightMenuByRow:(RightMenuRow)rightMenuRow {
  if (rightMenuRow == ReportRow) {
    [self presentReportAlertByProfileMapping:self.profileMapping];
    
  } else if (rightMenuRow == ClearChatRow) {
    [self presentAlertFromRightMenu:ClearChatRow];
  } else {
    [self presentAlertFromRightMenu:BlockUserRow];
  }
  
  [self dismissPopoverView];
}

- (void)presentAlertFromRightMenu:(RightMenuRow)rightMenuRow {
  NSString *titleText = rightMenuRow == ClearChatRow ? @"Очистить чат" : [self.profileMapping.IsBlocked boolValue] ? @"Разблокировать" : @"Заблокировать";
  [UIAlertHelper alert:nil title:titleText cancelButton:@"Нет" successButton:@"Да" successCompletion:^(UIAlertAction *action) {
    if (rightMenuRow == ClearChatRow) {
      [Helpers showSpinner];
      [[ServerManager sharedManager] cleanChatByUserId:self.profileMapping.UserId withCompletion:^(BOOL status, NSString *errorMessage) {
        [Helpers hideSpinner];
        if (status) {
          [self returnToChatListController];
        }
      }];
    } else {
      if ([self.profileMapping.IsBlocked boolValue]) {
        [Helpers showSpinner];
        [[ServerManager sharedManager] unblockUserByIdUser:self.profileMapping.UserId withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
          [Helpers hideSpinner];
          [WToast showWithText:@"Профиль разблокирован" duration:3.0];
          [self loadProfileFromServer];
        }];
      } else {
        [Helpers showSpinner];
        [[ServerManager sharedManager] blockUserByUserId:self.profileMapping.UserId withCompletion:^(BOOL status, NSString *errorMessage) {
          [Helpers hideSpinner];
          if (status) {
            [WToast showWithText:@"Профиль заблокирован" duration:3.0];
            [self returnToChatListController];
          }
        }];
      }
    }
  }];
}

- (void)returnToChatListController {
  UIViewController *vc = nil;
  for (UIViewController *viewController in self.navigationController.viewControllers) {
    if ([viewController isKindOfClass:[ChatListViewController class]]) {
      vc = viewController;
      break;
    }
  }
  
  if (vc != nil) {
    [self.navigationController popToViewController:vc animated:YES];
  } else {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [(TabBarViewController *)DELEGATE.window.rootViewController setSelectedIndex:ChatListTabBarIndex];
  }
}

- (void)selectAttachMenuByRow:(AttachMenuRow)attachMenuRow isTranslateChats:(BOOL)isTranslateChats {
  self.textField.inputView = nil;
  [self.textField reloadInputViews];
  
  switch (attachMenuRow) {
    case StickerMenuRow: [self presentStickers]; break;
      
    case TranslateMenuRow: {
      isTranslateChats = !isTranslateChats;
      [[ServerManager sharedManager] setUserSettingsWithParams:@{@"Token" : [Helpers getAccessToken], @"TranslateChats" : @(isTranslateChats)} withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      }];
    } break;
      
    case GiftMenuRow: [self presentGiftVC]; break;
      
    case GalleryMenuRow: [self presentPhotoGallery]; break;
      
    case CameraMenuRow: [self presentCameraPhoto]; break;
  }
  
  [self dismissPopoverView];
}

- (void)presentStickers {
  self.stickerView = [StickerView setupStickerView];
  self.stickerView.delegate = self;
  [self.stickerView loadStickerFromServerByDictionary:self.selectedGroupSticker];
  self.textField.inputView = self.stickerView;
  [self hiddenKeyboardView:NO];
  [self.textField becomeFirstResponder];
}

- (IBAction)attachmentDidTap:(UIButton *)sender {
  [self presentPopoverByIsRightMenu:NO andSize:CGSizeMake(225, 240) andWYPopoverArrowDirection:WYPopoverArrowDirectionDown withSender:sender];
}

- (void)presentPopoverByIsRightMenu:(BOOL)isRight andSize:(CGSize)size andWYPopoverArrowDirection:(WYPopoverArrowDirection)direction withSender:(UIButton *)sender {
  if (self.popoverController == nil) {
    UIButton *button = (UIButton *)sender;
    RightMenuViewController *rightMenuVC = (RightMenuViewController *)[Helpers createCustomVCByStoryboardName:@"RightMenu" andStoryboardId:RIGHT_MENU_STORYBOARD_ID];
    rightMenuVC.isRightMenu = isRight;
    rightMenuVC.preferredContentSize = size;
    rightMenuVC.delegate = self;
    rightMenuVC.profileMapping = self.profileMapping;
    self.popoverController = [[WYPopoverController alloc] initWithContentViewController:rightMenuVC];
    
    self.popoverController.passthroughViews = @[button];
    self.popoverController.wantsDefaultContentAppearance = YES;
    self.popoverController.dismissOnPassthroughViewTap = YES;
    self.popoverController.theme.arrowBase = 20;
    self.popoverController.theme.arrowHeight = 7;
    self.popoverController.delegate = self;
    
    [self.popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:direction animated:YES options:WYPopoverAnimationOptionFadeWithScale];
  } else {
    [self dismissPopoverView];
  }
}

- (IBAction)emojiDidTap:(UIButton *)sender {
  if([self.textField.inputView isKindOfClass:[ISEmojiView class]]) {
    self.textField.inputView = nil;
    [self changeEmojiButtonImage:NO];
  } else {
    ISEmojiView *emojiView = [[ISEmojiView alloc] initWithTextField:self.textField delegate:self];
    self.textField.inputView = emojiView;
    [self changeEmojiButtonImage:YES];
  }
  
  [self.textField becomeFirstResponder];
}

- (void)presentCameraPhoto {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypeCamera];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нет камеры" title:@"Отсутствует камера"];
  }
}

- (void)presentPhotoGallery {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нету галлереи" title:@"Отсутствует галлерея"];
  }
}

- (void)presentPickerViewBySourceType:(UIImagePickerControllerSourceType)sourceType {
  [Helpers showSpinner];
  UIImagePickerController *picker = [UIImagePickerController new];
  picker.delegate = self;
  picker.allowsEditing = NO;
  picker.sourceType = sourceType;
  if (sourceType == UIImagePickerControllerSourceTypeCamera) {
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
  }
  [self presentViewController:picker animated:YES completion:^{
    [Helpers hideSpinner];
  }];
}

#pragma mark - Delegate

- (void)presentGiftScreen {
  [self presentGiftVC];
}

- (void)sendGiftBySelectGiftMapping:(GiftMapping *)giftMapping {
  NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObject:[Helpers getAccessToken] forKey:@"Token"];
  [mutDict setObject:self.profileMapping.UserId forKey:@"ToUserId"];
  [mutDict setObject:giftMapping.IdGift forKey:@"GiftId"];
  
  [[ServerManager sharedManager] sendGiftMessageWithParams:mutDict withCompletion:^(BOOL status, NSString *errorMessage) {
    if (status) {
      [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"ReturnToChat" object:nil];
    } else {
      [UIAlertHelper alert:nil title:errorMessage];
    }
  }];
}

- (void)showImageInputMessageByMessageMapping:(MessageMapping *)messageMapping {
  [self prepareFullImageViewByMessageMapping:messageMapping];
}

- (void)showImageOutputMessageByMessageMapping:(MessageMapping *)messageMapping {
  [self prepareFullImageViewByMessageMapping:messageMapping];
}

- (void)prepareFullImageViewByMessageMapping:(MessageMapping *)messageMapping {
  self.fullImageView = [FullImageView prepareFullImageView];
  self.fullImageView.delegate = self;
  [self.fullImageView preparePhotoImageViewByMessageMapping:messageMapping];
  [self.fullImageView.layer addAnimation:[Helpers setupAnimation] forKey:kCATransition];
  [self.view addSubview:self.fullImageView];
}

- (void)dismissFullImageView {
  [Helpers dismissCustomView:self.fullImageView];
}

- (void)selectStickerByDictionaryMapping:(DictionaryMapping *)dictionaryMapping {
  if (dictionaryMapping != nil && self.profileMapping != nil) {
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"ToUserId" : self.profileMapping.UserId,
                             @"StickerId" : dictionaryMapping.IdDictionary
                             };
    
    [[ServerManager sharedManager] sendStickerWithParams:params withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      if (responseStatusModel.code != nil && [responseStatusModel.code integerValue] >= 500) {
        if ([responseStatusModel.code integerValue] == 530) {
          [self presentPaymentAlertWithMessage:responseStatusModel.localized];
        } else if ([responseStatusModel.code integerValue] == 531) {
          [self presentMotivationByPage:DialogsPage];
        } else {
          [UIAlertHelper alert:nil title:responseStatusModel.localized];
        }
      } else {
        [self hiddenKeyboardView:YES];
        [self.textField becomeFirstResponder];
        [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
      }
    }];
  }
}

- (void)resendImageMessage {
  [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
}

- (void)resendSoundMessage {
  [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
}

- (void)resendTextMessage:(UITableViewCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
  NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
  NSArray *eventsOnThisDay = [self.messagesDictionary objectForKey:dateRepresentingThisDay];
  MessageMapping *mapping = [eventsOnThisDay objectAtIndex:indexPath.row];
  
  [self sendMessageToServerByText:mapping.Message];
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  [Helpers showSpinner];
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  if (image) {
    NSData *fileData = UIImageJPEGRepresentation([image fixOrientation], 0.8);
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"ToUserId" : self.profileMapping.UserId
                             };
    
    [[ServerManager sharedManager] sendImageMessageWithParams:params byImageData:fileData withCompletion:^(BOOL status, NSString *errorMessage) {
      if (status) {
        [self loadMessagesFromServerByIsNewMessage:YES andIsOldMessage:NO];
      } else {
        [UIAlertHelper alert:nil title:errorMessage];
      }
    }];
  }
  
  [picker dismissViewControllerAnimated:YES completion:^{
    [Helpers hideSpinner];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)messages {
  if (!_messages) {
    _messages = [NSMutableArray new];
  }
  return _messages;
}

- (NSMutableDictionary *)messagesDictionary {
  if (!_messagesDictionary) {
    _messagesDictionary = [NSMutableDictionary dictionary];
  }
  return _messagesDictionary;
}

- (NSNumber *)prepareNumberFormatterByString:(NSString *)stringNumber {
  NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
  numberFormatter.numberStyle = NSNumberFormatterNoStyle;
  return [numberFormatter numberFromString:stringNumber];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - ISEmojiViewDelegate

-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
  self.textField.text = [self.textField.text stringByAppendingString:emoji];
  [self checkSendButtonByText:self.textField.text];
}

-(void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
  if (self.textField.text.length > 0) {
    NSRange lastRange = [self.textField.text rangeOfComposedCharacterSequenceAtIndex:self.textField.text.length-1];
    self.textField.text = [self.textField.text substringToIndex:lastRange.location];
  }
  [self checkSendButtonByText:self.textField.text];
}

@end

