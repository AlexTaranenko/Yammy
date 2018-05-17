//
//  HotPageCardView.m
//  Yammy
//
//  Created by Alex on 2/21/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HotPageCardView.h"
#import "HotPageImageCollectionViewCell.h"
#import "HHPageView.h"

@interface HotPageCardView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutletCollection(CustomButton) NSArray *strawberryButtons;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomButton *messageButton;
@property (weak, nonatomic) IBOutlet CustomButton *kingLikeButton;
@property (weak, nonatomic) IBOutlet CustomButton *giftButton;
@property (weak, nonatomic) IBOutlet UILabel *countPhotosLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet CircularImageView *bgIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutIconImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutIconImageWidth;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPageOriginX;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPageOriginY;
@property (weak, nonatomic) IBOutlet HHPageView *verticalPageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutVerticalPageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutVerticalOriginY;

@property (strong, nonatomic) ProfileMapping *profileMapping;

@end

@implementation HotPageCardView

+ (HotPageCardView *)setupHotPageCardViewWithFrame:(CGRect)frame {
  HotPageCardView *hotPageCardView = (HotPageCardView *)[[[NSBundle mainBundle] loadNibNamed:@"HotPageCardView" owner:self options:nil] firstObject];
  hotPageCardView.frame = frame;
  hotPageCardView.layer.cornerRadius = 20.0;
  hotPageCardView.clipsToBounds = YES;
  [hotPageCardView.collectionView registerNib:[UINib nibWithNibName:@"HotPageImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier];
  [hotPageCardView prepareIconImageViewByImageName:nil andAlpha:0.0];
  
  return hotPageCardView;
}

- (void)prepareHotPageInterfaceByProfileMapping:(ProfileMapping *)profileMapping {
  self.profileMapping = profileMapping;
  self.countPhotosLabel.text = profileMapping.Photos.count > 0 ? [NSString stringWithFormat:@"%lu", (unsigned long)profileMapping.Photos.count] : @"0";
  [Helpers prepareStrawberryButtons:self.strawberryButtons withProfile:self.profileMapping isMyProfile:NO];
  [Helpers prepareLabelsByProfileMapping:profileMapping withLabel:self.nameLabel];
  [self prepareVerticalPageViewByTotalPages:profileMapping.Photos.count];
}

- (void)prepareVerticalPageViewByTotalPages:(NSInteger)total {
  
  [self.verticalPageView setBaseScrollView:self.collectionView];
  
  //Set HHPageView Type: Horizontal or Vertical
  [self.verticalPageView setHHPageViewType:HHPageViewVerticalType];
  
  //Set Images for Active and Inactive state.
  [self.verticalPageView setImageActiveState:[UIImage imageNamed:@"active_dot_icon"] InActiveState:[UIImage  imageNamed:@"normal_dot_icon"]];
  
  //Tell HHPageView, the number of pages you want to show.
  [self.verticalPageView setNumberOfPages:total];
  
  //Tell HHPageView to show page from this page index.
  [self.verticalPageView setCurrentPage:1];
  
  //Show when you ready!
  [self.verticalPageView load];
  
  self.layoutVerticalPageHeight.constant = 11 * total;
  self.layoutVerticalOriginY.constant += self.layoutVerticalPageHeight.constant / 2.0 - 10;
}

- (void)prepareIconImageViewByImageName:(NSString *)imageName andAlpha:(CGFloat)alpha {
  self.iconImageView.alpha = alpha;
  self.bgIconImageView.alpha = alpha;
  self.iconImageView.image = [UIImage imageNamed:imageName];
  self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)updateIconImageViewFrameByValue:(CGFloat)value {
  CGRect frame = self.bgIconImageView.frame;
  
  self.layoutIconImageWidth.constant = value > 0 ?  80.0 * (value * 1.8) : 80.0;
  self.layoutIconImageHeight.constant = value > 0 ?  80.0 * (value * 1.8) : 80.0;
  
  frame.size.width = self.layoutIconImageWidth.constant;
  frame.size.height = self.layoutIconImageHeight.constant;
  
  self.bgIconImageView.frame = frame;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSLog(@"Count images: %ld", self.profileMapping.Photos.count);
  return self.profileMapping.Photos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  HotPageImageCollectionViewCell *hotPageImageCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:kHotPageImageCollectionCellIdentifier forIndexPath:indexPath];
  ImageMapping *imageMapping = [self.profileMapping.Photos objectAtIndex:indexPath.row];
  [hotPageImageCollectionViewCell preparePhotoImageByImageMapping:imageMapping];
  return hotPageImageCollectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (self.delegate != nil) {
    [self.delegate presentProfileVC];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGFloat pageheight = self.collectionView.frame.size.height;
  CGFloat currentPage = (self.collectionView.contentOffset.y / pageheight) + 1;
  
  if (0.0f != fmodf(currentPage, 1.0f)) {
    [self.verticalPageView updateStateForPageNumber:currentPage + 1];
  } else {
    [self.verticalPageView updateStateForPageNumber:currentPage];
  }
}

- (IBAction)photoCameraDidTap:(UITapGestureRecognizer *)sender {
  if (self.delegate != nil) {
    [self.delegate presentPhotoBrowser];
  }
}

- (IBAction)strawberryDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate selectStrawberryByCustomButton:sender];
  }
}

- (IBAction)messageDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentChatVC];
  }
}

- (IBAction)kingLikeDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendKingLike];
  }
}

- (IBAction)giftDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentGiftVC];
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

