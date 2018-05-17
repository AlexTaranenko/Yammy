//
//  ServiceCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 19.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ServiceCollectionViewCell.h"

@interface ServiceCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ServiceCollectionViewCell

- (void)prepareBorderCell {
  self.layer.borderWidth = 0.5;
  self.layer.borderColor = RGB(235, 235, 235).CGColor;
  self.clipsToBounds = YES;
}

- (void)prepareServiceCollectionByServicesMapping:(ServicesMapping *)servicesMapping {
  self.titleLabel.text = servicesMapping.Title;
  
  [self prepareIconImageByUrlPath:servicesMapping.Icon.Url];
}

- (void)prepareServiceWithSubtitleByServicesMapping:(ServicesMapping *)servicesMapping {
  self.titleLabel.text = servicesMapping.Title;
  self.subTitleLabel.text = servicesMapping.Description;
  
  [self prepareIconImageByUrlPath:servicesMapping.Icon.Url];
}

- (void)prepareServiceCollectionByGiftMapping:(GiftMapping *)giftMapping {
  self.titleLabel.text = giftMapping.Title ?: @"";
  self.subTitleLabel.text = giftMapping.Description ?: @"";
  [self prepareIconImageByUrlPath:giftMapping.Image.Url];
}

- (void)prepareIconImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.iconImageView.frame.size.width;
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

- (IBAction)sendServiceDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendServiceByCell:self];
  }
}

@end

