//
//  AllOpenProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllOpenProfileTableViewCell.h"

@interface AllOpenProfileTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *sexImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *containerButtons;

@end

@implementation AllOpenProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllOpenProfileCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  [self prepareSexImageByMapping:activityLineMapping];
  
  NSURL *urlImage = [self urlImageByUrlPath:activityLineMapping.MediaUrl];
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

- (void)prepareSexImageByMapping:(ActivityLineMapping *)activityLineMapping {
  if ([activityLineMapping.EventType integerValue] == OpenedPrivateProfile ||
      [activityLineMapping.EventType integerValue] == OpenedPrivateProfileForGift) {
    self.containerButtons.hidden = YES;
    if (activityLineMapping.FromUser != nil && [activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
      [self hiddedCustomImage:NO];
    } else {
      [self hiddedCustomImage:YES];
    }
  } else {
    self.containerButtons.hidden = NO;
    if (activityLineMapping.FromUser != nil && [activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
      [self hiddedCustomImage:NO];
    } else {
      [self hiddedCustomImage:YES];
    }
  }
  
  self.sexImageView.contentMode = UIViewContentModeCenter;
}

- (NSURL *)urlImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.8;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  return [NSURL URLWithString:urlString];
}

- (void)hiddedCustomImage:(BOOL)isHidden {
  self.sexImageView.hidden = isHidden;
  if (isHidden == NO) {
    [self prepareCustomImage:self.borderImageView color:RGB(249, 0, 64) width:3.0];
    [self prepareCustomImage:self.photoImageView color:RGB(250, 250, 250) width:2.0];
    [self prepareCustomImage:self.sexImageView color:RGB(250, 250, 250) width:2.0];
  } else {
    [self prepareCustomImage:self.borderImageView color:[UIColor clearColor] width:0.0];
    [self prepareCustomImage:self.photoImageView color:[UIColor clearColor] width:0.0];
    [self prepareCustomImage:self.sexImageView color:[UIColor clearColor] width:0.0];
  }
}

- (void)prepareCustomImage:(CustomImageView *)customImageView color:(UIColor *)color width:(CGFloat)width {
  customImageView.borderWidth = width;
  customImageView.borderColor = color;
}

- (IBAction)presentPrivateProfileDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentPrivateProfileByCell:self];
  }
}

- (IBAction)cancelDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelOpenProfileByCell:self];
  }
}

- (IBAction)acceptDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate acceptOpenProfileByCell:self];
  }
}

@end

