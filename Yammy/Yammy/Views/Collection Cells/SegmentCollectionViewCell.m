//
//  SegmentCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "SegmentCollectionViewCell.h"

@interface SegmentCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *indicatorView;

@end

@implementation SegmentCollectionViewCell

- (void)prepareSegmentByTitle:(NSString *)title andCurrentIndex:(NSInteger)currentIndex andSelectedIndex:(NSInteger)selectedIndex {
  self.titleLabel.text = title;
  if (currentIndex == selectedIndex) {
    self.indicatorView.backgroundColor = RGB(246, 0, 64);
  } else {
    self.indicatorView.backgroundColor = [UIColor clearColor];
  }
}

@end

