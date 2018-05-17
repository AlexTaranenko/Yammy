//
//  GiftMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 05.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "GiftMessageTableViewCell.h"

@interface GiftMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *giftPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomButton *sendGiftButton;

@end

@implementation GiftMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareGiftMessageCellByMessageMapping:(MessageMapping *)messageMapping {
  
  self.nameLabel.text = messageMapping.SubTitle;
  [self.sendGiftButton setTitle:messageMapping.Title forState:UIControlStateNormal];
  self.sendGiftButton.hidden = [messageMapping.Gift.Type integerValue] == DefaultType ? NO : YES;
  if (messageMapping.Title.length == 0) {
    self.sendGiftButton.hidden = YES;
  } else {
    self.sendGiftButton.hidden = NO;
  }
  [self prepareGiftImageByGiftMapping:messageMapping.Gift];
}

- (void)prepareGiftOutputMessageByMessageMapping:(MessageMapping *)messageMapping {
  self.nameLabel.text = messageMapping.SubTitle;
  self.sendGiftButton.hidden = YES;
  [self prepareGiftImageByGiftMapping:messageMapping.Gift];
}

- (void)prepareGiftImageByGiftMapping:(GiftMapping *)giftMapping {
  NSString *urlPath = giftMapping.Image.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.giftPhotoImageView.frame.size.width;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [self.giftPhotoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.giftPhotoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.giftPhotoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (IBAction)sendGiftDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentGiftScreen];
  }
}

@end

