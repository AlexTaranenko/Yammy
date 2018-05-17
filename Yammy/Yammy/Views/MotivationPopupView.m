//
//  MotivationPopupView.m
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationPopupView.h"
#import "MotivationCollectionViewCell.h"

@interface MotivationPopupView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *containerTitleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet CustomButton *receiveYaMaxButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *containerCloseView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) MotivationModel *motivationModel;

@end

@implementation MotivationPopupView

+ (MotivationPopupView *)createMotivationPopupView {
  MotivationPopupView *motivationPopupView = (MotivationPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationPopupView" owner:self options:nil] firstObject];
  motivationPopupView.frame = [UIScreen mainScreen].bounds;
  
  motivationPopupView.collectionView.layer.cornerRadius = 10;
  motivationPopupView.collectionView.clipsToBounds = YES;
  
  [motivationPopupView.collectionView registerNib:[UINib nibWithNibName:@"MotivationCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kMotivationCollectionCellIdentifier];

  return motivationPopupView;
}

- (void)prepareMotivationInterfaceBy:(MotivationPage)motivationPage {
  self.motivationModel = [MotivationModel getMotivationByPage:motivationPage];
  [self prepareMotivationByModel:self.motivationModel];
  [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:motivationPage inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
}

- (void)prepareMotivationByModel:(MotivationModel *)model {
  self.motivationModel = model;
  self.containerTitleView.hidden = model.motivationPage == YaMaxPage ? NO : YES;
  self.titleLabel.text = model.titleMotivation;
  self.subTitleLabel.text = model.subTitleMotivation;
  [self.receiveYaMaxButton setTitle:model.receiveYaMaxTitle forState:UIControlStateNormal];
  self.pageControl.numberOfPages = [MotivationModel titlesMotivationArray].count;
  self.pageControl.currentPage = model.motivationPage;
  self.containerCloseView.hidden = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [MotivationModel titlesMotivationArray].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MotivationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMotivationCollectionCellIdentifier forIndexPath:indexPath];
  MotivationModel *model = [[MotivationModel titlesMotivationArray] objectAtIndex:indexPath.row];
  [cell prepareMotivationCellByModel:model];
  return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat pageWidth = self.collectionView.frame.size.width;
  CGFloat currentPage = (self.collectionView.contentOffset.x / pageWidth);
  
  if (0.0f != fmodf(currentPage, 1.0f)) {
    self.pageControl.currentPage = currentPage + 1;
  } else {
    self.pageControl.currentPage = currentPage;
  }
  
  MotivationModel *model = [[MotivationModel titlesMotivationArray] objectAtIndex:self.pageControl.currentPage];
  [self prepareMotivationByModel:model];
}

- (IBAction)receiveYaMaxDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentMotivationServicesScreen];
  }
}

- (IBAction)firstCloseDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationPopup];
  }
}

- (IBAction)billingDidTap:(UIButton *)sender {
  
}

- (IBAction)secondCloseDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationPopup];
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
