//
//  OrientationRegisterTableViewCell.m
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "OrientationRegisterTableViewCell.h"

@interface OrientationRegisterTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *orientationImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkboxImageView;

@end

@implementation OrientationRegisterTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareNameByGenderMapping:(DictionaryMapping *)mapping {
  self.nameLabel.text = mapping.Title;
  [self prepareImageIconByImageMapping:mapping.Icon];
}

- (void)prepareImageIconByImageMapping:(ImageMapping *)imageMapping {
  
  NSString *urlPath = imageMapping.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.orientationImageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [self.orientationImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.orientationImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
        self.orientationImageView.contentMode = UIViewContentModeScaleAspectFill;
      });
    }];
  } else {
    self.orientationImageView.image = [UIImage imageNamed:@"placeholder_image"];
    self.orientationImageView.contentMode = UIViewContentModeScaleAspectFill;
  }
}

- (void)setDictionary:(NSDictionary *)dictionary {
  self.nameLabel.text = [dictionary objectForKey:@"title"];
  NSString *urlPath = [dictionary objectForKey:@"image"];
  if (urlPath.length > 0) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.orientationImageView.frame.size.width * 1.5;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    
    NSURL *urlImage = [NSURL URLWithString:urlString];
    if (urlImage) {
      [self.orientationImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
          self.orientationImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
          self.orientationImageView.contentMode = UIViewContentModeScaleAspectFill;
        });
      }];
    } else {
      self.orientationImageView.image = [UIImage imageNamed:@"placeholder_image"];
      self.orientationImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
  } else {
    self.orientationImageView.image = [UIImage imageNamed:@"placeholder_image"];
    self.orientationImageView.contentMode = UIViewContentModeScaleAspectFill;
  }
}

- (void)selectedCheckBoxImageView:(BOOL)select {
  if (select) {
    self.checkboxImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  } else {
    self.checkboxImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  }
}

- (void)selectSquareCheckBox:(BOOL)select {
  if (select) {
    self.checkboxImageView.image = [UIImage imageNamed:@"selected_checkbox"];
  } else {
    self.checkboxImageView.image = [UIImage imageNamed:@"select_checkbox"];
  }
}

@end

