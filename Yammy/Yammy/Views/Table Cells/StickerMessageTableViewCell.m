//
//  StickerMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "StickerMessageTableViewCell.h"

@interface StickerMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *stickerImageView;

@end

@implementation StickerMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareStickerMessageByMessageMapping:(MessageMapping *)messageMapping {
  if (messageMapping.Sticker.Image != nil) {
    NSString *urlPath = messageMapping.Sticker.Image.Url;
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.stickerImageView.frame.size.width * 1.5;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    
    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [self.stickerImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.stickerImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        });
      }];
    } else {
      self.stickerImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    self.stickerImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

@end

