//
//  CirclesCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 9/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CirclesCollectionViewCell.h"

@interface CirclesCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CirclesCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.layer.borderWidth = 1.f;
  self.layer.borderColor = [UIColor clearColor].CGColor;
  self.clipsToBounds = YES;
}

- (void)setupRoundCell {
  self.layer.cornerRadius = self.frame.size.height / 2.f;
  self.clipsToBounds = YES;
}

- (void)setPreferencesMapping:(PreferencesMapping *)preferencesMapping {
  NSString *urlPath = preferencesMapping.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [[SDWebImageManager sharedManager] loadImageWithURL:urlImage options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
      
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

@end

