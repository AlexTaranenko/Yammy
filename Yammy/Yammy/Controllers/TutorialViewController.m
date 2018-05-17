//
//  TutorialViewController.m
//  Yammy
//
//  Created by Alex on 2/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "TutorialViewController.h"
#import "TutorialCollectionViewCell.h"

//static const NSInteger kCountSlides = 4;

@interface TutorialViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collecrtionView;

@property (strong, nonatomic) NSArray *slidesArray;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.tutorialType == HotPageTutorialType) {
    self.slidesArray = @[@"tutorial_image_1", @"tutorial_image_2", @"tutorial_image_3", @"tutorial_image_4"];
  } else if (self.tutorialType == MyPublicTutorialType) {
    self.slidesArray = @[@"my_profile_public_tutorial"];
  } else if (self.tutorialType == MyPrivateTutorialType) {
    self.slidesArray = @[@"my_profile_private_1", @"my_profile_private_2", @"my_profile_private_3"];
  } else if (self.tutorialType == PeoplesTutorialType) {
    self.slidesArray = @[@"people_tutorial_1", @"people_tutorial_2", @"people_tutorial_3"];
  } else if (self.tutorialType == ChatTutorialType) {
    self.slidesArray = @[@"chat_tutorial_1", @"chat_tutorial_2", @"chat_tutorial_3", @"chat_tutorial_4", @"chat_tutorial_5", @"chat_tutorial_6", @"chat_tutorial_7", @"chat_tutorial_8"];
  }
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.slidesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  return size;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TutorialCollectionViewCell *tutorialCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kTutorialCollectionCellIdentifier forIndexPath:indexPath];
  
  NSString *imageName = [self.slidesArray objectAtIndex:indexPath.row];
  [tutorialCollectionCell prepareImageByName:imageName];
  
  return tutorialCollectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row + 1 == self.slidesArray.count) {
    [self dismissViewControllerAnimated:YES completion:^{
      if (self.tutorialType == HotPageTutorialType) {
        [Helpers saveShowHotPageTutorial];
      } else if (self.tutorialType == MyPublicTutorialType) {
        [Helpers saveShowMyPublicProfileTutorial];
      } else if (self.tutorialType == MyPrivateTutorialType) {
        [Helpers saveShowMyPrivateProfileTutorial];
      } else if (self.tutorialType == PeoplesTutorialType) {
        [Helpers saveShowPeoplesTutorial];
      } else if (self.tutorialType == ChatTutorialType) {
        [Helpers saveShowChatTutorial];
      }
    }];
  } else {
    [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
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

