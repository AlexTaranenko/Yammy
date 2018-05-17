//
//  DragView.m
//  Yammy
//
//  Created by Alex on 06.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "DragView.h"

@interface DragView()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation DragView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  
  if (self) {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DragView" owner:self options:nil] firstObject];
  }
  
  return self;
}

- (void)setPreferencesMapping:(PreferencesMapping *)preferencesMapping {
  NSString *urlPath = preferencesMapping.Icon.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width;
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

