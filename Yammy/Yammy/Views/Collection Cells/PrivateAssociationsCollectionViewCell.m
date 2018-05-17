//
//  PrivateAssociationsCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 16.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PrivateAssociationsCollectionViewCell.h"
#import "CornerView.h"

@interface PrivateAssociationsCollectionViewCell()

@property (weak, nonatomic) IBOutlet CircularImageView *photoImageView;

@end

@implementation PrivateAssociationsCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)preparePhotoImageViewBorder {
  self.photoImageView.layer.borderWidth = 1.f;
  self.photoImageView.layer.borderColor = RGB(214, 0, 65).CGColor;
  self.photoImageView.clipsToBounds = YES;
}

- (void)preparePhotoImageViewRadius {
  self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.height / 2.f;
  self.photoImageView.clipsToBounds = YES;
}

- (void)setPreferencesMapping:(PreferencesMapping *)preferencesMapping {
  NSString *urlPath = preferencesMapping.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width;
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
}

- (void)prepareCloseImageView {
  self.photoImageView.image = [UIImage imageNamed:@"close_profile_association_icon"];
}

@end

