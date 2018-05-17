//
//  HomeCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 06.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeCollectionViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *strawberryIconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPhotoImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutPhotoImageHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeCollectionViewCell

- (void)prepareForReuse {
  [super prepareForReuse];
  
  self.borderImageView.backgroundColor = [UIColor clearColor];
  self.photoImageView.image = nil;
  self.strawberryIconImageView.hidden = YES;
  self.titleLabel.text = nil;
  self.borderImageView.layer.borderWidth = 0.f;
  self.borderImageView.layer.borderColor = [UIColor clearColor].CGColor;
  self.strawberryIconImageView.clipsToBounds = YES;
}

- (void)prepareBorderPhotoImageView {
  self.borderImageView.backgroundColor = RGB(249, 0, 64);
  self.borderImageView.layer.borderWidth = 3.f;
  self.borderImageView.layer.borderColor = RGB(249, 0, 64).CGColor;
  self.borderImageView.clipsToBounds = YES;
  
  self.photoImageView.layer.borderWidth = 2.f;
  self.photoImageView.layer.borderColor = RGB(250, 250, 250).CGColor;
  self.photoImageView.clipsToBounds = YES;
}

- (void)prepareCornerRadiusForPhotoImageView {
  self.borderImageView.layer.cornerRadius = self.photoImageView.frame.size.height / 2.f;
  self.borderImageView.clipsToBounds = YES;
}

- (void)updatePhotoImageConstraintsByValue:(CGFloat)value {
  CGRect frame = self.borderImageView.frame;
  
  self.layoutPhotoImageWidth.constant = value;
  self.layoutPhotoImageHeight.constant = value;
  
  frame.size.width = self.layoutPhotoImageWidth.constant;
  frame.size.height = self.layoutPhotoImageHeight.constant;
  
  self.borderImageView.frame = frame;
}

- (void)hideStrawberryIconImageView:(BOOL)isHide {
  self.strawberryIconImageView.hidden = isHide;
}

- (void)setupPulseAnimation {
  CABasicAnimation *theAnimation;
  
  theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
  theAnimation.duration = 0.8;
  theAnimation.repeatCount = HUGE_VALF;
  theAnimation.autoreverses = YES;
  theAnimation.fromValue = [NSNumber numberWithFloat:1.0];
  theAnimation.toValue = [NSNumber numberWithFloat:0.0];
  [self.borderImageView.layer addAnimation:theAnimation forKey:@"animateOpacity"];
}

- (void)prepareCellByMapping:(ProfileMapping *)profileMapping {
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile:)];
  [self.strawberryIconImageView addGestureRecognizer:gesture];
  self.strawberryIconImageView.userInteractionEnabled = YES;
  
  [self prepareNameLabelByMapping:profileMapping];
  [self preparePhotoImageByMapping:profileMapping];
}

- (void)prepareNameLabelByMapping:(ProfileMapping *)profileMapping {
  NSMutableString *mutString = [NSMutableString new];
  if (profileMapping.FirstName.length > 0) {
    [mutString appendString:profileMapping.FirstName];
  }
  
  if (profileMapping.LastName.length > 0) {
    [mutString appendFormat:@" %@", profileMapping.LastName];
  }
  
  self.titleLabel.text = mutString;
}

- (void)preparePhotoImageByMapping:(ProfileMapping *)profileMapping {
  self.photoImageView.clipsToBounds = YES;
  
  if (profileMapping.PrimaryPhoto != nil) {
    [self setupPhotoImageByUrlPath:profileMapping.PrimaryPhoto.Url];
  } else if (profileMapping.Photos.count > 0) {
    ImageMapping *mapping = [profileMapping.Photos firstObject];
    [self setupPhotoImageByUrlPath:mapping.Url];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)setupPhotoImageByUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.layoutPhotoImageWidth.constant * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  [self.photoImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.photoImageView.image = image != nil ? image : [UIImage imageNamed:@"placeholder_image"];
    });
  }];
}

- (void)openProfile:(UIGestureRecognizer *)gesture {
  if (self.delegate != nil) {
    [self.delegate presentProfileScreenByCell:self];
  }
}

@end

