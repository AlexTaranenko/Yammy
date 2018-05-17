//
//  FullImageCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 3/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "FullImageCollectionViewCell.h"

@interface FullImageCollectionViewCell()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation FullImageCollectionViewCell

- (void)prepareFullImageCollectionCellByImageMapping:(ImageMapping *)imageMapping {
  self.scrollView.minimumZoomScale = 1.0;
  self.scrollView.maximumZoomScale = 6.0;
  
  if (imageMapping) {
    NSString *urlPath = imageMapping.Url;
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.photoImageView.frame.size.width * 2.0;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];

    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [Helpers showSpinner];
      [self.photoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [Helpers hideSpinner];
          self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
          self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        });
      }];
    } else {
      self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.photoImageView;
}

@end
