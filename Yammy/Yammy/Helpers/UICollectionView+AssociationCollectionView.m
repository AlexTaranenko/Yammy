//
//  UICollectionView+AssociationCollectionView.m
//  Yammy
//
//  Created by Alex on 24.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UICollectionView+AssociationCollectionView.h"
#import "PrivateAssociationsCollectionViewCell.h"
#import <objc/runtime.h>
#import "Yammy-Swift.h"

static CGFloat kTopMargin = 8.f;

NSString * const kPreferencesPropertyKey = @"kPreferencesPropertyKey";
NSString * const kPrivateProfileMappingPropertyKey = @"kPrivateProfileMappingPropertyKey";

@implementation UICollectionView (AssociationCollectionView)

@dynamic preferencesArray;

- (void)setPreferencesArray:(NSArray *)preferencesArray {
  objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kPreferencesPropertyKey), preferencesArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)preferencesArray {
  return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kPreferencesPropertyKey));
}

- (void)setPrivateProfileMapping:(PrivateProfileMapping *)privateProfileMapping {
  objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kPrivateProfileMappingPropertyKey), privateProfileMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PrivateProfileMapping *)privateProfileMapping {
  return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kPrivateProfileMappingPropertyKey));
}

#pragma mark - Methods

- (void)prepareAssociationCollectionView {
  [self registerNib:[UINib nibWithNibName:@"PrivateAssociationsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kPrivateAssociationsCollectionCellIdentifier];
  self.delegate = self;
  self.dataSource = self;
  //  self.transform = CGAffineTransformMakeRotation(M_PI);
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  if ([self.privateProfileMapping.PrivatePreferencesHidden boolValue] == NO) {
    return self.preferencesArray.count;
  } else {
    return 10;
  }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  PrivateAssociationsCollectionViewCell *privateAssociationsCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kPrivateAssociationsCollectionCellIdentifier forIndexPath:indexPath];
  
  [privateAssociationsCollectionCell preparePhotoImageViewBorder];
  [privateAssociationsCollectionCell layoutIfNeeded];
  [privateAssociationsCollectionCell preparePhotoImageViewRadius];
  
  if ([self.privateProfileMapping.PrivatePreferencesHidden boolValue] == NO) {
    PreferencesMapping *mapping = [self.preferencesArray objectAtIndex:indexPath.row];
    privateAssociationsCollectionCell.preferencesMapping = mapping;
  } else {
    [privateAssociationsCollectionCell prepareCloseImageView];
  }
  
  return privateAssociationsCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat heightCell = collectionView.frame.size.height - (kTopMargin * 2);
  return CGSizeMake(heightCell, heightCell);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return -20;
}

@end

