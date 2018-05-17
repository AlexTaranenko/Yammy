//
//  HotPageCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 10/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HotPageCollectionViewCell.h"
#import "HotPageImageCollectionViewCell.h"

@interface HotPageCollectionViewCell()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *imagesArray;

@end

@implementation HotPageCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)prepareCornerRadius {
  self.layer.cornerRadius = self.frame.size.width / 2.f;
  self.clipsToBounds = YES;
}

- (void)prepareCollectionView {
  [self.collectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
}

- (void)reloadCollectionViewByArray:(NSArray *)imagesArray {
  if (imagesArray.count > 0) {
    self.imagesArray = imagesArray;
  } else {
    self.imagesArray = @[[ImageMapping new]];
  }
  
  [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.imagesArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HotPageImageCollectionViewCell *hotPageImageCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier forIndexPath:indexPath];
  ImageMapping *mapping = [self.imagesArray objectAtIndex:indexPath.row];
  
  [hotPageImageCollectionCell prepareCornerRadius];
  [hotPageImageCollectionCell preparePhotoImageByImageMapping:mapping];
  
  return hotPageImageCollectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != nil) {
    [self.delegate selectItemByCell:self];
  }
}

@end

