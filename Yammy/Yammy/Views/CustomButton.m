//
//  CustomButton.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)setCornerRadius:(CGFloat)cornerRadius {
  self.layer.cornerRadius = cornerRadius;
  self.clipsToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius {
  return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  self.layer.borderWidth = borderWidth;
  self.clipsToBounds = borderWidth > 0;
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

@end

