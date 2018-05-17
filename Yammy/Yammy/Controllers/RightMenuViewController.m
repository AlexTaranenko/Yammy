//
//  RightMenuViewController.m
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "RightMenuViewController.h"
#import "RightMenuTableViewCell.h"

@interface RightMenuViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titlesArray;

@property (assign, nonatomic) BOOL isTranslateChats;

@end

@implementation RightMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isRightMenu) {
    self.titlesArray = @[@{@"title" : @"Пожаловаться", @"image" : @"complain_icon"},
                         @{@"title" : @"Очистить чат", @"image" : @"clear_chat_icon"},
                         @{@"title" : self.profileMapping != nil && [self.profileMapping.IsBlocked boolValue] ? @"Разблокировать" : @"Заблокировать", @"image" : self.profileMapping != nil && [self.profileMapping.IsBlocked boolValue] ? @"unlock_icon" : @"lock_icon"}];
  } else {
    [[ServerManager sharedManager] getUserSettingsWithCompletion:^(UserSettingsMapping *userSettingsMapping, NSString *errorMessage) {
      self.isTranslateChats = NO;
      if (userSettingsMapping.TranslateChats != nil) {
        self.isTranslateChats = [userSettingsMapping.TranslateChats boolValue];
      }

      self.titlesArray = @[@{@"title" : @"Отправить стикер", @"image" : @"stickers_icon"},
                           @{@"title" : self.isTranslateChats ? @"Выключить переводчик" : @"Включить переводчик", @"image" : @"translate_icon"},
                           @{@"title" : @"Отправить подарок", @"image" : @"chat_gift_button"},
                           @{@"title" : @"Выбрать из галереи", @"image" : @"gallery_icon"},
                           @{@"title" : @"Сделать фотографию", @"image" : @"chat_photo_button"}];
      
      [self.tableView reloadData];
    }];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RightMenuTableViewCell *rightMenuCell = [tableView dequeueReusableCellWithIdentifier:kRightMenuCellIdentifier];
  NSDictionary *dict = [self.titlesArray objectAtIndex:indexPath.row];
  rightMenuCell.dictionary = dict;
  return rightMenuCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.isRightMenu) {
    if (self.delegate != nil) {
      [self.delegate selectRightMenuByRow:indexPath.row];
    }
  } else {
    if (self.delegate != nil) {
      [self.delegate selectAttachMenuByRow:indexPath.row isTranslateChats:self.isTranslateChats];
    }
  }
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

