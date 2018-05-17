//
//  AllLikeTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllLikeTableViewCell.h"

@interface AllLikeTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *bigLikeImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AllLikeTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllLikeByMapping:(LikeMapping *)likeMapping {
  self.nameLabel.text = likeMapping.FromUser.FirstName;
  self.messageLabel.text = likeMapping.SubTitle;
  
  [self preparePhotoImageByImageMapping:likeMapping.FromUser.PrimaryPhoto];
  
  if ([likeMapping.IsSuper boolValue] == YES) {
    [self prepareSuperLikeUserProfile:likeMapping.FromUser];
  } else {
    [self prepareLikeByUserProfile:likeMapping.FromUser];
  }
}

- (void)prepareAllLikeByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  [self loadImageByUrlPath:activityLineMapping.MediaUrl];
  
  if ([activityLineMapping.EventType integerValue] == Liked) {
    [self prepareLikeByUserProfile:activityLineMapping.FromUser];
  } else {
    [self prepareSuperLikeUserProfile:activityLineMapping.FromUser];
  }
}

- (void)prepareLikeByUserProfile:(ProfileMapping *)profileMapping {
  [self prepareIconImage:RGB(229, 119, 177) imageName:@"like_icon"];
  if ([profileMapping.HasPrivateProfile boolValue]) {
    [self checkHasPrivateProfile:YES];
  } else {
    [self checkHasPrivateProfile:NO];
  }
}

- (void)prepareSuperLikeUserProfile:(ProfileMapping *)profileMapping {
  [self prepareIconImage:RGB(253, 100, 76) imageName:@"king_like_icon"];
  if ([profileMapping.HasPrivateProfile boolValue]) {
    [self checkHasPrivateProfile:YES];
  } else {
    [self checkHasPrivateProfile:NO];
  }
}

- (void)checkHasPrivateProfile:(BOOL)isHas {
  if (isHas) {
    [self prepareCustomImage:self.borderImageView color:RGB(249, 0, 64) width:3.0];
    [self prepareCustomImage:self.photoImageView color:RGB(250, 250, 250) width:2.0];
  } else {
    [self prepareCustomImage:self.borderImageView color:[UIColor clearColor] width:0.0];
    [self prepareCustomImage:self.photoImageView color:[UIColor clearColor] width:0.0];
  }
}

- (void)preparePhotoImageByImageMapping:(ImageMapping *)imageMapping {
  if (imageMapping != nil) {
    NSString *urlPath = imageMapping.Url;
    [self loadImageByUrlPath:urlPath];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)loadImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.8;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  NSURL *url = [NSURL URLWithString:urlString];
  if (url) {
    [self.photoImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)prepareCustomImage:(CustomImageView *)customImageView color:(UIColor *)color width:(CGFloat)width {
  customImageView.borderColor = color;
  customImageView.borderWidth = width;
}

- (void)prepareIconImage:(UIColor *)color imageName:(NSString *)imageName {
  self.bigLikeImageView.backgroundColor = color;
  self.bigLikeImageView.image = [UIImage imageNamed:imageName];
}

@end

