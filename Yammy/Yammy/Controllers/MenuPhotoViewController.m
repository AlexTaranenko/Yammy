//
//  MenuPhotoViewController.m
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MenuPhotoViewController.h"
#import "MenuPhotoTableViewCell.h"

@interface MenuPhotoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation MenuPhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isMyPublicPhoto) {
    self.titlesArray = @[@{@"image" : @"main_photo_icon", @"title" : @"Главное фото"},
                         @{@"image" : @"move_photo_to_profile", @"title" : @"Переместить в приватный профиль"},
                         @{@"image" : @"photo_delete_icon", @"title" : @"Удалить"}];
  } else if (self.isMyPublicEditPhoto) {
    self.titlesArray = @[@{@"image" : @"boomerang_icon", @"title" : @"Сделать бумеранг"},
                         @{@"image" : @"photo_library_icon", @"title" : @"Выбрать из галлереи"},
                         @{@"image" : @"photo_camera_icon", @"title" : @"Сделать фотографию"}];
  } else {
    self.titlesArray = @[
  //@{@"image" : @"move_photo_to_profile", @"title" : @"Переместить в публичный профиль"},
                         @{@"image" : @"photo_delete_icon", @"title" : @"Удалить"}
                         ];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MenuPhotoTableViewCell *menuPhotoCell = [tableView dequeueReusableCellWithIdentifier:kMenuPhotoCellIdentifier];
  NSDictionary *dict = [self.titlesArray objectAtIndex:indexPath.row];
  menuPhotoCell.dictionary = dict;
  return menuPhotoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != nil) {
    [self.delegate closePopoverByIndexPath:indexPath];
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

