//
//  PublicProfileServicesTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PublicProfileServicesTableViewCell.h"
#import "ServicesCollectionViewCell.h"
#import "PagedCollectionLayout.h"
#import "ServicesMapping.h"

static CGFloat kMarginCell = 8.f;
static NSInteger kUserServicesCollectionViewTag = 0;

@interface PublicProfileServicesTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *containerLabelView;
@property (weak, nonatomic) IBOutlet UIView *containerCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *userServicesArray;
@property (strong, nonatomic) NSArray *servicesArray;

@end

@implementation PublicProfileServicesTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self setupServicesCollectionViewCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setupCollectionViewTag:(NSInteger)tag {
  self.collectionView.tag = tag;
}

- (void)prepareUserServicesByArray:(NSArray *)userServicesArray {
  [self prepareActiveServices];
  self.userServicesArray = userServicesArray;
  [self.collectionView reloadData];
}

- (void)prepareServicesByArray:(NSArray *)servicesArray {
  [self prepareNotActiveServices];
  self.servicesArray = servicesArray;
  [self.collectionView reloadData];
}

- (void)prepareTitleLabelByText:(NSString *)textForLabel {
  self.titleLabel.text = textForLabel;
}

- (void)prepareActiveServices {
  [self changeContainerColorsByColor:RGB(248, 248, 248)];
}

- (void)prepareNotActiveServices {
  [self changeContainerColorsByColor:[UIColor whiteColor]];
}

- (void)changeContainerColorsByColor:(UIColor *)color {
  self.containerLabelView.backgroundColor = color;
  self.containerCollectionView.backgroundColor = color;
}

- (void)setupServicesCollectionViewCell {
  [self.collectionView registerNib:[UINib nibWithNibName:@"ServicesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kServicesCollectionCellIdentifier];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat widthCell = collectionView.frame.size.width / 2;
  return CGSizeMake(widthCell, collectionView.frame.size.height - (kMarginCell * 2));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  CGFloat widthCell = collectionView.frame.size.width / 2;
  CGFloat leftInset = (collectionView.frame.size.width - widthCell) / 2;
  CGFloat rightInset = leftInset;
  return UIEdgeInsetsMake(0, leftInset, 0, rightInset);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return kMarginCell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return kMarginCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if (collectionView.tag == kUserServicesCollectionViewTag) {
    return self.userServicesArray.count;
  } else {
    return self.servicesArray.count;
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ServicesCollectionViewCell *servicesCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kServicesCollectionCellIdentifier forIndexPath:indexPath];
  
  ServicesMapping *servicesMapping = nil;
  if (collectionView.tag == kUserServicesCollectionViewTag) {
    UserServicesMapping *userServicesMapping = [self.userServicesArray objectAtIndex:indexPath.row];
    servicesMapping = userServicesMapping.Service;
    servicesCollectionCell.backgroundColor = [UIColor whiteColor];
  } else {
    servicesMapping = [self.servicesArray objectAtIndex:indexPath.row];
    servicesCollectionCell.backgroundColor = RGB(248, 248, 248);
  }
  
  [servicesCollectionCell prepareServicesCollectionCellByServicesMapping:servicesMapping];
  
  return servicesCollectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView.tag == kUserServicesCollectionViewTag) {
    UserServicesMapping *userServicesMapping = [self.userServicesArray objectAtIndex:indexPath.row];
    [Helpers showSpinner];
    [[ServerManager sharedManager] disableServicesByServiceId:userServicesMapping.IdUserServices withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (responseStatusModel.localized == nil) {
        if (self.delegate != nil) {
          [self.delegate reloadAllServices];
        }
      }
    }];
  } else {
    ServicesMapping *servicesMapping = [self.servicesArray objectAtIndex:indexPath.row];
    [Helpers showSpinner];
    [[ServerManager sharedManager] enableServicesByServiceId:servicesMapping.IdServices withCompletion:^(ResponseStatusModel *responseStatusModel, NSString *errorMessage) {
      [Helpers hideSpinner];
      if (responseStatusModel.localized == nil) {
        if (self.delegate != nil) {
          [self.delegate reloadAllServices];
        }
      }
    }];
  }
}

@end

