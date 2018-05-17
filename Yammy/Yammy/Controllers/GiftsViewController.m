//
//  GiftsViewController.m
//  Yammy
//
//  Created by Alex on 12/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GiftsViewController.h"
#import "GiftCollectionViewCell.h"
#import "SegmentCollectionViewCell.h"
#import "CreditsCollectionViewCell.h"
#import "ServiceCollectionViewCell.h"

typedef enum : NSUInteger {
  SegmentCollectionViewTag = 10,
  FreeCollectionViewTag,
} GiftCollectionViewTag;

typedef enum : NSUInteger {
  ServicesSegmentRow = 0,
  CreditsSegmentRow,
  GiftsSegmentRow,
} SegmentCollectionRow;

@interface GiftsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GiftCollectionViewCellDelegate, CreditsCollectionViewCellDelegate, ServiceCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *segmentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *freeGiftCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSArray *segmentTitleArray;
@property (strong, nonatomic) NSArray *freeGiftsArray;
@property (strong, nonatomic) NSArray *creditsArray;
@property (strong, nonatomic) NSArray *servicesArray;

@property (assign, nonatomic) NSInteger selectedSegmentRow;

@end

@implementation GiftsViewController

- (NSArray *)segmentTitleArray {
  return @[@"Услуги", @"Кредиты", @"Подарки"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.selectedSegmentRow = GiftsSegmentRow;
  
  [self prepareCancelBarButtonItem];
  
  [self setupCollectionsViewTag];
  [self prepareTitleLabel];
  
  [self loadDataFromServer];
  
  [ServerManager sharedManager].forbiddenBlock = ^(NSString *errorMessage) {
    [Helpers hideSpinner];
    [UIAlertHelper alert:nil title:errorMessage cancelButton:@"Отмена" successButton:@"Пополнить" successCompletion:^(UIAlertAction *action) {
      [self presentServicesScreen];
    }];
  };
  
  [[NSNotificationCenter defaultCenter] addObserverForName:@"ReturnToChat" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
    [self.navigationController popViewControllerAnimated:YES];
  }];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
//  [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"ReturnToChat"];
}

#pragma mark - Private

- (void)loadDataFromServer {
  
  dispatch_group_t group = dispatch_group_create();
  
  [Helpers showSpinner];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getAllGiftsWithType:DefaultType WithCompletion:^(NSArray *giftsArray, NSString *errorMessage) {
    self.freeGiftsArray = giftsArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getAllGiftsWithType:CoinsType WithCompletion:^(NSArray *giftsArray, NSString *errorMessage) {
    self.creditsArray = giftsArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  [[ServerManager sharedManager] getAllGiftsWithType:ServiceType WithCompletion:^(NSArray *giftsArray, NSString *errorMessage) {
    self.servicesArray = giftsArray;
    dispatch_group_leave(group);
  }];
  
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [Helpers hideSpinner];
    [self.freeGiftCollectionView reloadData];
  });
}

- (void)setupCollectionsViewTag {
  self.segmentCollectionView.tag = SegmentCollectionViewTag;
  self.freeGiftCollectionView.tag = FreeCollectionViewTag;
}

- (void)prepareTitleLabel {
  NSString *balance = [ServerManager sharedManager].myProfileMapping.Balance != nil ? [NSString stringWithFormat:@"%ld", (long)[[ServerManager sharedManager].myProfileMapping.Balance integerValue]] : @"0";
  NSMutableAttributedString *mutAttrString = [[NSMutableAttributedString alloc] initWithString:@"Баланс кредитов: " attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_REGULAR size:12.0]}];
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:balance attributes:@{NSFontAttributeName : [UIFont fontWithName:NOTOSANSDISPLAY_BOLD size:24.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
  [mutAttrString appendAttributedString:attrString];
  
  self.titleLabel.attributedText = mutAttrString;
}

#pragma mark - Collection

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == SegmentCollectionViewTag) {
    return CGSizeMake(collectionView.frame.size.width / 3.0, collectionView.frame.size.height);
  } else {
    return CGSizeMake(collectionView.frame.size.width / 2.0 - 4.0, collectionView.frame.size.width / 2.0 + 56.0);
  }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag == SegmentCollectionViewTag) {
    return self.segmentTitleArray.count;
  } else {
    if (self.selectedSegmentRow == ServicesSegmentRow) {
      return self.servicesArray.count;
    } else if (self.selectedSegmentRow == CreditsSegmentRow) {
      return self.creditsArray.count;
    } else {
      return self.freeGiftsArray.count;
    }
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == SegmentCollectionViewTag) {
    SegmentCollectionViewCell *segmentCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSegmentCollectionCellIdentifier forIndexPath:indexPath];
    NSString *title = [self.segmentTitleArray objectAtIndex:indexPath.row];
    [segmentCollectionCell prepareSegmentByTitle:title andCurrentIndex:indexPath.row andSelectedIndex:self.selectedSegmentRow];
    return segmentCollectionCell;
  } else {
    if (self.selectedSegmentRow == ServicesSegmentRow) {
      ServiceCollectionViewCell *serviceCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"serviceCollectionCell" forIndexPath:indexPath];
      serviceCollectionCell.delegate = self;
      GiftMapping *giftMapping = [self.servicesArray objectAtIndex:indexPath.row];
      [serviceCollectionCell prepareServiceCollectionByGiftMapping:giftMapping];
      return serviceCollectionCell;
    } else if (self.selectedSegmentRow == CreditsSegmentRow) {
      CreditsCollectionViewCell *creditsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCreditsCollectionCellIdentifier forIndexPath:indexPath];
      creditsCollectionCell.delegate = self;
      GiftMapping *giftMapping = [self.creditsArray objectAtIndex:indexPath.row];
      [creditsCollectionCell prepareCreditsCollectionCellByGiftMapping:giftMapping];
      return creditsCollectionCell;
    } else {
      GiftCollectionViewCell *giftCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"giftCollectionCell" forIndexPath:indexPath];
      giftCollectionCell.delegate = self;
      GiftMapping *mapping = [self.freeGiftsArray objectAtIndex:indexPath.row];
      [giftCollectionCell prepareGiftCollectionByGiftMapping:mapping];
      return giftCollectionCell;
    }
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == SegmentCollectionViewTag) {
    self.selectedSegmentRow = indexPath.row;
    
    [self.segmentCollectionView reloadData];
    [self.freeGiftCollectionView reloadData];
  } else {
    if (self.selectedSegmentRow == ServicesSegmentRow) {
      GiftMapping *mapping = [self.servicesArray objectAtIndex:indexPath.row];
      [self sendObjectByMapping:mapping];
    } else if (self.selectedSegmentRow == CreditsSegmentRow) {
      GiftMapping *mapping = [self.creditsArray objectAtIndex:indexPath.row];
      [self sendObjectByMapping:mapping];
    } else {
      GiftMapping *mapping = [self.freeGiftsArray objectAtIndex:indexPath.row];
      [self sendObjectByMapping:mapping];
    }
  }
}

- (void)sendServiceByCell:(UICollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.freeGiftCollectionView indexPathForCell:cell];
  GiftMapping *mapping = [self.servicesArray objectAtIndex:indexPath.row];
  [self sendObjectByMapping:mapping];
}

- (void)sendCreditByCell:(UICollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.freeGiftCollectionView indexPathForCell:cell];
  GiftMapping *mapping = [self.creditsArray objectAtIndex:indexPath.row];
  [self sendObjectByMapping:mapping];
}

- (void)sendGiftByCell:(UICollectionViewCell *)cell {
  NSIndexPath *indexPath = [self.freeGiftCollectionView indexPathForCell:cell];
  GiftMapping *mapping = [self.freeGiftsArray objectAtIndex:indexPath.row];
  [self sendObjectByMapping:mapping];
}

- (void)sendObjectByMapping:(GiftMapping *)mapping {
  if (self.profileMapping == nil) {
    if (self.delegate != nil) {
      [self.delegate sendGiftBySelectGiftMapping:mapping];
    }
  } else {
    NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                             @"ToUserId" : self.profileMapping.UserId,
                             @"GiftId" : mapping.IdGift
                             };
    [self sendGiftWithParams:params];
  }
}

- (void)sendGiftWithParams:(NSDictionary *)params {
  [Helpers showSpinner];
  [[ServerManager sharedManager] sendGiftWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (status) {
      if (self.delegate != nil) {
        [self.delegate reloadGiftsAtTheProfile];
      }
      
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      [UIAlertHelper alert:nil title:errorMessage];
    }
  }];
}

#pragma mark - Actions

- (void)cancelButtonDidTap:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
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

