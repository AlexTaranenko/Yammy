//
//  BlockedCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "BlockedCollectionViewCell.h"

@interface BlockedCollectionViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *statusImageView;

@end

@implementation BlockedCollectionViewCell

- (void)prepareBlockedCollectionCellByProfileMapping:(ProfileMapping *)profileMapping {
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelShowProfile)];
  [self.titleLabel addGestureRecognizer:tap];
  self.titleLabel.userInteractionEnabled = YES;
  
  self.titleLabel.text = profileMapping.FirstName;
  [self prepareStatusImage];
  
  self.statusImageView.hidden = [profileMapping.IsOnline boolValue] ? NO : YES;
  
  NSString *urlPath = profileMapping.PrimaryPhoto.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
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

- (void)prepareStatusImage {
  self.statusImageView.borderWidth = @(2);
  self.statusImageView.borderColor = [UIColor whiteColor];
}

- (void)labelShowProfile {
  if (self.delegate != nil) {
    [self.delegate showProfileByCollectionCell:self];
  }
}

- (IBAction)openProfileDidTap:(UIControl *)sender {
  if (self.delegate != nil) {
    [self.delegate showProfileByCollectionCell:self];
  }
}

- (IBAction)unlockDidTap:(UIControl *)sender {
  if (self.delegate != nil) {
    [self.delegate unlockUserByCollectionCell:self];
  }
}

@end
