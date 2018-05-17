//
//  StickerView.m
//  Yammy
//
//  Created by Alex on 2/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "StickerView.h"
#import "StickerCollectionViewCell.h"

@interface StickerView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *stickersArray;

@end

@implementation StickerView

+ (StickerView *)setupStickerView {
  StickerView *stickerView = (StickerView *)[[[NSBundle mainBundle] loadNibNamed:@"StickerView" owner:self options:nil] firstObject];
  [stickerView setupCollectionCell];
  return stickerView;
}

- (void)setupCollectionCell {
  [self.collectionView registerNib:[UINib nibWithNibName:@"StickerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kStickerCollectionCellIdentifier];
}

- (void)loadStickerFromServerByDictionary:(DictionaryMapping *)dictionaryMapping {
  [[ServerManager sharedManager] getStickersByDictionary:dictionaryMapping withCompletion:^(NSArray *stickersArray, NSString *errorMessage) {
    self.stickersArray = stickersArray;
    [self.collectionView reloadData];
  }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.stickersArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  StickerCollectionViewCell *stickerCollectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:kStickerCollectionCellIdentifier forIndexPath:indexPath];
  DictionaryMapping *mapping = [self.stickersArray objectAtIndex:indexPath.row];
  [stickerCollectionCell prepareStickerCollectionCellByDictionaryMapping:mapping];
  return stickerCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width / 4, collectionView.frame.size.height / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != nil) {
    DictionaryMapping *mapping = [self.stickersArray objectAtIndex:indexPath.row];
    [self.delegate selectStickerByDictionaryMapping:mapping];
  }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

