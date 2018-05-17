//
//  CircularImageView.m
//  Yammy
//
//  Created by Alex on 8/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CircularImageView.h"

@interface CircularImageView()

- (void)addMaskToBounds:(CGRect)bounds;

- (void)setup;

@end

@implementation CircularImageView

@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

#pragma mark -
#pragma mark - UIImageView override methods

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

- (id)initWithImage:(UIImage *)image {
  self = [super initWithImage:image];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setBorderWidth:(NSNumber *)borderWidth {
  _borderWidth    = borderWidth;
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (void)setBorderColor:(UIColor *)borderColor {
  _borderColor    = borderColor;
  [self setNeedsLayout];
  [self layoutIfNeeded];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self addMaskToBounds:self.frame];
}

#pragma mark -
#pragma mark - Private methods

- (void)addMaskToBounds:(CGRect)maskBounds {
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  
  CGPathRef maskPath = CGPathCreateWithEllipseInRect(maskBounds, NULL);
  maskLayer.bounds = maskBounds;
  maskLayer.path = maskPath;
  maskLayer.fillColor = [UIColor blackColor].CGColor;
  
  CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
  maskLayer.position = point;
  
  [self.layer setMask:maskLayer];
  
  if ([self.borderWidth integerValue] > 0) {
    
    //
    // And then create the outline layer
    //
    
    CAShapeLayer*   shape   = [CAShapeLayer layer];
    shape.bounds            = maskBounds;
    shape.path              = maskPath;
    shape.lineWidth         = [self.borderWidth doubleValue] * 2.0f;
    shape.strokeColor       = self.borderColor.CGColor;
    shape.fillColor         = [UIColor clearColor].CGColor;
    shape.position          = point;
    
    [self.layer addSublayer:shape];
  }
  
  CGPathRelease(maskPath);
}

- (void)setup {
  self.contentMode = UIViewContentModeScaleAspectFill;
  self.clipsToBounds = YES;
  
  self.borderWidth    = @0.0f;
  self.borderColor    = [UIColor whiteColor];
}

@end
