//
//  CornerView.m
//  Yammy
//
//  Created by Alex on 9/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CornerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CornerView

- (void)setCornerRadius:(CGFloat)cornerRadius {
  self.layer.cornerRadius = cornerRadius;
  self.layer.masksToBounds = cornerRadius > 0;
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (CGFloat)cornerRadius {
  return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  self.layer.borderWidth = borderWidth;
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (CGFloat)borderWidth {
  return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
  self.layer.borderColor = borderColor.CGColor;
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (UIColor *)borderColor {
  return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setIsAutouRounded:(BOOL)isAutouRounded {
  if (isAutouRounded) {
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
  } else {
    self.layer.cornerRadius = 0;
  }
  self.layer.masksToBounds = isAutouRounded;
}

- (BOOL)isAutouRounded {
  return self.isAutouRounded;
}

@end


@implementation AutoCornerView

@synthesize borderWidth     = _borderWidth;
@synthesize borderColor     = _borderColor;
@synthesize backgroundColor = _backgroundColor;
@synthesize lineCap         = _lineCap;
@synthesize lineDashPattern = _lineDashPattern;

- (id)init {
  self = [super init];
  
  if (self) {
    [self setup];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.contentMode = UIViewContentModeScaleAspectFill;
  self.clipsToBounds = YES;
  
  self.borderWidth      = @0.0f;
  self.borderColor      = [UIColor clearColor];
  self.backgroundColor  = [UIColor clearColor];
  self.lineCap = kCALineCapButt;
  self.lineDashPattern = @[@0, @0];
}

- (void)setBorderWidth:(NSNumber *)borderWidth {
  _borderWidth = borderWidth;
  [self updateLayouts];
}

- (void)setBorderColor:(UIColor *)borderColor {
  _borderColor = borderColor;
  [self updateLayouts];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  _backgroundColor = backgroundColor;
  [self updateLayouts];
}

- (void)setLineCap:(NSString *)lineCap {
  _lineCap = lineCap;
  [self updateLayouts];
}

- (void)setLineDashPattern:(NSArray<NSNumber *> *)lineDashPattern {
  _lineDashPattern = lineDashPattern;
  [self updateLayouts];
}

- (void)updateLayouts {
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self addMaskToBounds:self.frame];
}

- (void)addMaskToBounds:(CGRect)maskBounds {
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

  CGPathRef maskPath = CGPathCreateWithRoundedRect(maskBounds, 0, 0, NULL);
//  CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
  maskLayer.bounds = maskBounds;
  maskLayer.path = maskPath;
  maskLayer.fillColor = [UIColor blackColor].CGColor;
  
  CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
  maskLayer.position = point;
  
  [self.layer setMask:maskLayer];
  
  if ([self.borderWidth integerValue] > 0) {
    CAShapeLayer*   shape   = [CAShapeLayer layer];
    shape.bounds            = maskBounds;
    shape.path              = maskPath;
    shape.lineWidth         = [self.borderWidth doubleValue];
    shape.strokeColor       = self.borderColor.CGColor;
    shape.fillColor         = self.backgroundColor.CGColor;
    shape.lineCap           = self.lineCap;
    shape.lineDashPattern   = self.lineDashPattern;
    shape.position          = point;
    [self.layer addSublayer:shape];
  }
  
  CGPathRelease(maskPath);
}

@end
