//
//  GiftCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 19.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GiftCollectionViewCell.h"

@interface GiftCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GiftCollectionViewCell

- (void)prepareBorderCell {
  self.layer.borderWidth = 0.5;
  self.layer.borderColor = RGB(235, 235, 235).CGColor;
  self.clipsToBounds = YES;
}

- (void)prepareGiftCollectionByUserGiftMapping:(UserGiftMapping *)userGiftMapping {
  if (userGiftMapping.Gift != nil) {
    self.iconImageView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    [self prepareGiftCollectionByGiftMapping:userGiftMapping.Gift];
  }
}

- (void)prepareGiftCollectionByGiftMapping:(GiftMapping *)giftMapping {
  
  self.titleLabel.text = giftMapping.Title;
  
  NSString *urlPath = giftMapping.Image.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)(self.photoImageView.frame.size.width * 1.8), [Helpers getAccessToken]];
  NSURL *url = [NSURL URLWithString:urlString];
  if (url) {
    [self.photoImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
  }
}

- (IBAction)sendGiftDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendGiftByCell:self];
  }
}

@end

