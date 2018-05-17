//
//  CustomLabel.m
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

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

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
  }
  return self;
}

- (void)drawTextInRect:(CGRect)rect {
  self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
  
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize {
  CGSize size = [super intrinsicContentSize];
  size.width  += self.edgeInsets.left + self.edgeInsets.right;
  size.height += self.edgeInsets.top + self.edgeInsets.bottom;
  return size;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

