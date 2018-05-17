//
//  FullImageViewController.m
//  Yammy
//
//  Created by Alex on 3/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "FullImageViewController.h"
#import "FullImageCollectionViewCell.h"
#import <WYPopoverController/WYPopoverController.h>
#import "MenuPhotoViewController.h"

@interface FullImageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MenuPhotoViewControllerDelegate, WYPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *rightMenuButton;

@property (strong, nonatomic) WYPopoverController *popoverController;

@end

@implementation FullImageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  if (self.isMyProfile == NO) {
    self.rightMenuButton.hidden = YES;
  } else {
    [self prepareRightButton];
  }
  
  [self prepareBackBarButtonItem];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [Helpers prepareStatusBarWithColor:[UIColor blackColor]];
  [Helpers changeNavBarColor:self.navigationController.navigationBar andColor:[UIColor blackColor]];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
  });
}

- (void)prepareRightButton {
  NSLayoutConstraint * heightConstraint = [self.rightMenuButton.heightAnchor constraintEqualToConstant:40];
  NSLayoutConstraint * widthConstraint = [self.rightMenuButton.widthAnchor constraintEqualToConstant:40];
  [widthConstraint setActive:YES];
  [heightConstraint setActive:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.photosArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FullImageCollectionViewCell *fullImageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kFullImageCollectionCellIdentifier forIndexPath:indexPath];
  
  ImageMapping *mapping = [self.photosArray objectAtIndex:indexPath.row];
  [fullImageCollectionCell prepareFullImageCollectionCellByImageMapping:mapping];
  
  return fullImageCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)backButtonDidTap:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rightMenuDidTap:(UIButton *)sender {
  if (self.popoverController == nil) {
    UIButton *button = (UIButton *)sender;
    MenuPhotoViewController *menuPhotoVC = (MenuPhotoViewController *)[Helpers createCustomVCByStoryboardName:@"MenuPhoto" andStoryboardId:MENU_PHOTO_STORYBOARD_ID];
    menuPhotoVC.isMyPublicPhoto = self.isMyPublicProfile;
    if (self.isMyPublicProfile) {
      menuPhotoVC.preferredContentSize = CGSizeMake(310, 140);
    } else {
      menuPhotoVC.preferredContentSize = CGSizeMake(310, 50);
    }
    
    menuPhotoVC.delegate = self;
    self.popoverController = [[WYPopoverController alloc] initWithContentViewController:menuPhotoVC];
    self.popoverController.passthroughViews = @[button];
    self.popoverController.wantsDefaultContentAppearance = YES;
    self.popoverController.dismissOnPassthroughViewTap = YES;
    self.popoverController.theme.arrowBase = 20;
    self.popoverController.theme.arrowHeight = 7;
    self.popoverController.delegate = self;
    
    [self.popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES options:WYPopoverAnimationOptionFadeWithScale];
  } else {
    [self dismissPopoverView];
  }
}

- (void)dismissPopoverView {
  [self.popoverController dismissPopoverAnimated:YES completion:^{
    [self popoverControllerDidDismissPopover:self.popoverController];
  }];
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
  if (controller == self.popoverController) {
    self.popoverController = nil;
  }
}

- (void)closePopoverByIndexPath:(NSIndexPath *)indexPath {
  
  CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
  CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
  NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
  
  if (self.isMyPublicProfile) {
    switch (indexPath.row) {
      case AvatarPhotoRow:
        [self setupAvatarByIndexPath:visibleIndexPath];
        break;
        
      case MoveToPrivateProfileRow:
        [self movePhotoByIndexPath:visibleIndexPath andPath:MOVE_PHOTO_TO_PRIVATE];
        break;
        
      case DeletePhotoRow:
        [self deletePhotoByIndexPath:visibleIndexPath];
        break;
    }
  } else {
    switch (indexPath.row + 1) {
      case MoveToPrivateProfileRow:
        [self movePhotoByIndexPath:visibleIndexPath andPath:MOVE_PHOTO_TO_PUBLIC];
        break;
        
      case DeletePhotoRow:
        [self deletePhotoByIndexPath:visibleIndexPath];
        break;
        
      default:
        break;
    }
  }
  
  [self dismissPopoverView];
}

- (void)setupAvatarByIndexPath:(NSIndexPath *)indexPath {
  if (self.photosArray.count > 0) {
    ImageMapping *imageMapping = [self.photosArray objectAtIndex:indexPath.row];
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] setupAvatarPhotoWithParams:@{@"Token" : [Helpers getAccessToken], @"Id" : imageMapping.IdImage} withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
    }];
  }
}

- (void)movePhotoByIndexPath:(NSIndexPath *)indexPath andPath:(NSString *)path {
  if (self.photosArray.count > 0) {
    ImageMapping *imageMapping = [self.photosArray objectAtIndex:indexPath.row];
    
    [self movePhotoWithParams:@{@"Token" : [Helpers getAccessToken], @"Id" : imageMapping.IdImage} withUrlPath:path andIndexPath:indexPath];
  }
}

- (void)movePhotoWithParams:(NSDictionary *)params withUrlPath:(NSString *)path andIndexPath:(NSIndexPath *)indexPath {
  [Helpers showSpinner];
  [[ServerManager sharedManager] movePhotoToProfileWithParams:params andPath:path withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    [self updateItemsWithIndexPath:indexPath];
  }];
}

- (void)deletePhotoByIndexPath:(NSIndexPath *)indexPath {
  if (self.photosArray.count > 0) {
    ImageMapping *imageMapping = [self.photosArray objectAtIndex:indexPath.row];
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] deletePhotoWithParams:@{@"Token" : [Helpers getAccessToken], @"Id" : imageMapping.IdImage} withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (status) {
        [self updateItemsWithIndexPath:indexPath];
      }
    }];
  }
}

- (void)updateItemsWithIndexPath:(NSIndexPath *)indexPath {
  [self.photosArray removeObjectAtIndex:indexPath.row];
  [self.collectionView reloadData];
  if (self.photosArray.count == 0) {
    [self dismissViewControllerAnimated:YES completion:nil];
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

