//
//  StickerCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 2/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "StickerCollectionViewCell.h"

@interface StickerCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation StickerCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)prepareStickerCollectionCellByDictionaryMapping:(DictionaryMapping *)dictionaryMapping {
  NSString *urlPath = dictionaryMapping.Image.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = 200.f;
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

@end

