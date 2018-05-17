//
//  AllGiftTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllGiftTableViewCell.h"
#import "ActivityLineMapping.h"

@interface AllGiftTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *fromPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet CustomImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) ActivityLineMapping *activityLineMapping;

@end

@implementation AllGiftTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllGiftCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  
  self.activityLineMapping = activityLineMapping;
  self.titleLabel.text = activityLineMapping.Title;
  self.fromLabel.text = activityLineMapping.SubTitle;
  
  [self preparePhoroImageByImageView:self.fromPhotoImageView andProfileMapping:activityLineMapping.FromUser];
  [self prepareGiftByGiftMapping:activityLineMapping.Gift];
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
    CGFloat width = self.fromPhotoImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

- (void)prepareGiftByGiftMapping:(GiftMapping *)giftMapping {
  NSString *urlPath = giftMapping.Image.Url;
  if (urlPath.length > 0) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.fromPhotoImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [self.giftImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.giftImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
          self.giftImageView.contentMode = UIViewContentModeScaleAspectFill;
        });
      }];
    } else {
      self.giftImageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    self.giftImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (IBAction)rejectDidTap:(CustomButton *)sender {
  [Helpers showSpinner];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsFroReplyRequestByIsAccept:NO] withCompletin:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (status) {
      // To Do
    }
  }];
}

- (IBAction)acceptDidTap:(CustomButton *)sender {
  [Helpers showSpinner];
  [[ServerManager sharedManager] replyRequestWithParams:[self paramsFroReplyRequestByIsAccept:YES] withCompletin:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    if (status) {
      // To Do
    }
  }];
}

- (NSDictionary *)paramsFroReplyRequestByIsAccept:(BOOL)isAccept {
  return @{@"Token" : [Helpers getAccessToken],
           @"ActivityId" : self.activityLineMapping.IdActivityLine,
           @"Answer" : @(isAccept)
           };
}

@end

