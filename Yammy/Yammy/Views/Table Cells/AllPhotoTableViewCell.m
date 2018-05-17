//
//  AllPhotoTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllPhotoTableViewCell.h"

@interface AllPhotoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *sexImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;

@end

@implementation AllPhotoTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllPhotoCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  if (activityLineMapping.FromUser != nil) {
    if ([activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
      [self hiddenSexImageView:NO];
      [self preparePhotoImageBorder:YES];
      self.sexImageView.contentMode = UIViewContentModeCenter;
    } else {
      [self hiddenSexImageView:YES];
      [self preparePhotoImageBorder:NO];
    }
  } else {
    [self hiddenSexImageView:YES];
    [self preparePhotoImageBorder:NO];
  }
  
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

- (void)preparePhotoImageBorder:(BOOL)isHas {
  if (isHas) {
    [self prepareCustomImageView:self.borderImageView color:RGB(249, 0, 64) width:3.0];
    [self prepareCustomImageView:self.photoImageView color:RGB(250, 250, 250) width:2.0];
    [self prepareCustomImageView:self.sexImageView color:RGB(250, 250, 250) width:2.0];
  } else {
    [self prepareCustomImageView:self.borderImageView color:[UIColor clearColor] width:0.0];
    [self prepareCustomImageView:self.photoImageView color:[UIColor clearColor] width:0.0];
    [self prepareCustomImageView:self.sexImageView color:RGB(250, 250, 250) width:2.0];
  }
}

- (void)prepareCustomImageView:(CustomImageView *)customImageView color:(UIColor *)color width:(CGFloat)width {
  customImageView.borderWidth = width;
  customImageView.borderColor = color;
}

- (void)hiddenSexImageView:(BOOL)hidden {
  self.sexImageView.hidden = hidden;
}

@end

