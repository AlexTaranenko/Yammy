//
//  AllSendedGiftTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllSendedGiftTableViewCell.h"

@interface AllSendedGiftTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerProfileView;

@end

@implementation AllSendedGiftTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllSendedGiftByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfileDidTap)];
  [self.containerProfileView addGestureRecognizer:gesture];
  self.containerProfileView.userInteractionEnabled = YES;
  
  self.titleLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  
  [self preparePhoroImageByImageView:self.photoImageView andProfileMapping:activityLineMapping.FromUser];
  
  NSURL *urlImage = [self urlImageByGiftMapping:activityLineMapping.Gift];
  if (urlImage) {
    [self.giftImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.giftImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.giftImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (NSURL *)urlImageByGiftMapping:(GiftMapping *)giftMapping {
  NSString *urlPath = giftMapping.Image.Url;
  if (urlPath) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.giftImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

- (void)preparePhoroImageByImageView:(CustomImageView *)circularImageView andProfileMapping:(ProfileMapping *)profileMapping {
  NSURL *urlImage = [self urlImageByProfileMapping:profileMapping];
  if (urlImage) {
    [circularImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        circularImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    circularImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (NSURL *)urlImageByProfileMapping:(ProfileMapping *)profileMapping {
  NSString *urlPath = profileMapping.PrimaryPhoto.Url;
  if (urlPath) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.photoImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

- (IBAction)sendDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendGiftByCell:self];
  }
}

- (void)openProfileDidTap {
  if (self.delegate != nil) {
    [self.delegate openProfileAllSendedGiftByCell:self];
  }
}

@end

