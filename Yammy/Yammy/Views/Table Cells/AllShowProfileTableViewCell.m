//
//  AllShowProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllShowProfileTableViewCell.h"

@interface AllShowProfileTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *sexImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AllShowProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareSexImageBorderByColor:(UIColor *)color {
  self.sexImageView.borderWidth = 2.0;
  self.sexImageView.borderColor = color;
}

- (void)prepareBorderImageByColor:(UIColor *)color width:(CGFloat)width {
  self.borderImageView.borderWidth = width;
  self.borderImageView.borderColor = color;
}

- (void)preparePhotoImageByColor:(UIColor *)color width:(CGFloat)width {
  self.photoImageView.borderWidth = width;
  self.photoImageView.borderColor = color;
}

- (void)prepareSexImageBackgroundByColor:(UIColor *)color {
  self.sexImageView.backgroundColor = color;
}

- (void)prepareSexImageTintColorByColor:(UIColor *)color {
  self.sexImageView.tintColor = color;
}

- (void)prepareSexImageByName:(NSString *)imageName {
  self.sexImageView.image = [UIImage imageNamed:imageName];
}

- (void)prepareAllShowProfileByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  [self prepareSexImageByActivityLineMapping:activityLineMapping];
  
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

- (NSURL *)urlImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.8;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  return [NSURL URLWithString:urlString];
}

- (void)prepareSexImageByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  if ([activityLineMapping.EventType integerValue] == VisitedProfile) {
    self.sexImageView.hidden = NO;
    [self prepareSexImageBorderByColor:RGB(250, 250, 250)];
  } else if ([activityLineMapping.EventType integerValue] == ProfileChanged) {
    self.sexImageView.hidden = YES;
    [self checkHasPrivateProfileMapping:activityLineMapping];
  } else {
    self.sexImageView.hidden = YES;
  }
}

- (void)checkHasPrivateProfileMapping:(ActivityLineMapping *)activityLineMapping {
  if ([activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
    [self preparePhotoImageByColor:RGB(250, 250, 250) width:2.0];
    [self prepareBorderImageByColor:RGB(249, 0, 64) width:3.0];
  } else {
    [self preparePhotoImageByColor:[UIColor clearColor] width:0.0];
    [self prepareBorderImageByColor:[UIColor clearColor] width:0.0];
  }
}

@end

