//
//  YearCalendarCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 8/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "YearCalendarCollectionViewCell.h"

@interface YearCalendarCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YearCalendarCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.layer.cornerRadius = self.frame.size.height / 2.0;
  self.clipsToBounds = YES;
}

- (void)setYearNumber:(NSNumber *)yearNumber {
  self.titleLabel.text = [yearNumber stringValue];
}

- (void)prepareBackgroundColor:(BOOL)isPrepare {
  if (isPrepare) {
    self.backgroundColor = RGB(231, 188, 201);
  } else {
    self.backgroundColor = [UIColor clearColor];
  }
}

@end
