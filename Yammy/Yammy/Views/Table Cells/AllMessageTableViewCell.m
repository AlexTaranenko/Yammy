//
//  AllMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllMessageTableViewCell.h"

@interface AllMessageTableViewCell()

@property (weak, nonatomic) IBOutlet CircularImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *sexImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AllMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllMessageCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  [self prepareSexImageBorder];
  
  NSURL *urlImage = [self urlImageByUrlPath:activityLineMapping.MediaUrl];
  if (urlImage) {
    [self.photoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        self.photoImageView.contentMode = UIViewContentModeCenter;
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
  
  self.sexImageView.contentMode = UIViewContentModeCenter;
}

- (NSURL *)urlImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.8;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  return [NSURL URLWithString:urlString];
}


- (void)prepareSexImageBorder {
  self.sexImageView.borderWidth = @(1.f);
  self.sexImageView.borderColor = RGB(255, 255, 255);
}

@end

