//
//  PagedCollectionLayout.m
//  Yammy
//
//  Created by Alex on 10/25/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PagedCollectionLayout.h"

@interface PagedCollectionLayout()

@property (nonatomic, assign) CGFloat previousOffset;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PagedCollectionLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
  NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
  
  // Imitating paging behaviour
  // Check previous offset and scroll direction
  if ((self.previousOffset > self.collectionView.contentOffset.x) && (velocity.x < 0.0f)) {
    self.currentPage = MAX(self.currentPage - 1, 0);
  } else if ((self.previousOffset < self.collectionView.contentOffset.x) && (velocity.x > 0.0f)) {
    self.currentPage = MIN(self.currentPage + 1, itemsCount - 1);
  }
  
  // Update offset by using item size + spacing
  CGFloat widthCell = self.collectionView.frame.size.width / 2;
  CGFloat updatedOffset = (widthCell + self.minimumInteritemSpacing) * self.currentPage;
  self.previousOffset = updatedOffset;
  
  return CGPointMake(updatedOffset, proposedContentOffset.y);
}

@end

