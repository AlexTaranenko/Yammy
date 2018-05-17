//
//  ServicesTableViewCell.m
//  Yammy
//
//  Created by Alex on 4/17/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ServicesTableViewCell.h"
#import "CornerView.h"

@interface ServicesTableViewCell()

@property (weak, nonatomic) IBOutlet CornerView *cornerView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet CustomButton *popularButton;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ServicesTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareServicesCellByServicesMapping:(ServicesMapping *)mapping isSelected:(BOOL)isSelected {
  self.titleLabel.text = mapping.Title;
  self.subTitleLabel.text = mapping.Description;
  self.popularButton.hidden = NO;
  
  [self prepareImageViewByServicesMapping:mapping.Icon.Url];
  [self prepareButtonByServicesMapping:mapping isSelected:isSelected];
  [self prepareCornerViewByIsSelected:isSelected];
}

- (void)prepareServicesCellByGiftMapping:(GiftMapping *)mapping {
  self.titleLabel.text = [NSString stringWithFormat:@"%@", mapping.Price];
  self.subTitleLabel.text = mapping.Title;
  self.popularButton.hidden = YES;
  
  self.cornerView.backgroundColor = [UIColor whiteColor];
  self.titleLabel.textColor = [UIColor blackColor];
  self.subTitleLabel.textColor = RGB(128, 128, 128);
  
  [self prepareImageViewByServicesMapping:mapping.Image.Url];
}

- (void)prepareImageViewByServicesMapping:(NSString *)urlPath {
//  NSString *urlPath = mapping.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.iconImageView.frame.size.width / 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [self.iconImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.iconImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.iconImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)prepareButtonByServicesMapping:(ServicesMapping *)mapping isSelected:(BOOL)isSelected {
  if (isSelected) {
    [self.popularButton setTitle:@"Подключено" forState:UIControlStateNormal];
    [self.popularButton setBackgroundColor:[UIColor whiteColor]];
  } else if (mapping.IsPopular != nil && [mapping.IsPopular boolValue]) {
    [self.popularButton setTitle:@"Популярно!" forState:UIControlStateNormal];
    [self.popularButton setBackgroundColor:RGB(255, 215, 0)];
  } else {
    self.popularButton.hidden = YES;
  }
}

- (void)prepareCornerViewByIsSelected:(BOOL)isSelected {
//- (void)prepareCornerViewByServicesMapping:(ServicesMapping *)mapping {
  if (isSelected) {
    self.cornerView.backgroundColor = RGB(249, 0, 64);
    self.titleLabel.textColor = [UIColor whiteColor];
    self.subTitleLabel.textColor = [UIColor whiteColor];
  } else {
    self.cornerView.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor blackColor];
    self.subTitleLabel.textColor = RGB(128, 128, 128);
  }
}

@end
