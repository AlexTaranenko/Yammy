//
//  CustomImageView.m
//  Yammy
//
//  Created by Alex on 8/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView

- (void)setBorderWidth:(CGFloat)borderWidth {
  self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
  return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
  self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
  return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
  return self.layer.cornerRadius;
}

- (void)setIsAutouRounded:(BOOL)isAutouRounded {
  if (isAutouRounded) {
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
  } else {
    self.layer.cornerRadius = 0;
  }
}

- (BOOL)isAutouRounded {
  return self.isAutouRounded;
}

- (void)setMasksToBounds:(BOOL)masksToBounds {
  self.layer.masksToBounds = masksToBounds;
}

- (BOOL)masksToBounds {
  return self.layer.masksToBounds;
}

@end
