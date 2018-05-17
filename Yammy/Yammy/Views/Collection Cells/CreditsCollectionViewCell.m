//
//  CreditsCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "CreditsCollectionViewCell.h"

@interface CreditsCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation CreditsCollectionViewCell

- (void)prepareCreditsCollectionCellByGiftMapping:(GiftMapping *)giftMapping {
  self.subTitleLabel.text = giftMapping.Title;
  self.titleLabel.text = [NSString stringWithFormat:@"%@", giftMapping.Price ?: @"0"];
  [self preparePhotoByImageMapping:giftMapping.Image];
}

- (void)preparePhotoByImageMapping:(ImageMapping *)imageMapping {
  if (imageMapping.Url != nil) {
    NSString *urlPath = imageMapping.Url;
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.photoImageView.frame.size.width * 1.5;
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

- (IBAction)sendCreditDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendCreditByCell:self];
  }
}

@end

