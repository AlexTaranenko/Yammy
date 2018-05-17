//
//  HotPageImageCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 10/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HotPageImageCollectionViewCell.h"

@interface HotPageImageCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation HotPageImageCollectionViewCell

- (void)prepareCornerRadius {
  self.layer.cornerRadius = self.frame.size.width / 2.f;
  self.clipsToBounds = YES;
}

- (void)preparePhotoImageByImageMapping:(ImageMapping *)imageMapping {
  if (imageMapping != nil) {
    NSString *urlPath = imageMapping.Url;
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = [self.profileMapping.IsPrivateProfileHidden boolValue] ? 10 : self.photoImageView.frame.size.width;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    
    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [self.photoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        });
      }];
    } else {
      self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

@end

