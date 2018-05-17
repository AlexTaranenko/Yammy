//
//  ActivityLineTitleView.m
//  Yammy
//
//  Created by Alex on 10/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ActivityLineTitleView.h"

@interface ActivityLineTitleView()

@property (strong, nonatomic) UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet CustomLabel *badgeNumberLabel;

@end

@implementation ActivityLineTitleView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupXib];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setupXib];
  }
  return self;
}

- (void)setupXib {
  self.view = [[[NSBundle mainBundle] loadNibNamed:@"ActivityLineTitleView" owner:self options:nil] firstObject];
  self.view.frame = self.bounds;
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:self.view];
  
  self.titleLabel.text = @"";
}

- (void)setTitleText:(NSString *)titleText {
  self.titleLabel.text = titleText;
}

- (NSString *)titleText {
  return self.titleLabel.text;
}

- (void)setBadgeNumberText:(NSString *)badgeNumberText {
  self.badgeNumberLabel.text = badgeNumberText;
}

- (NSString *)badgeNumberText {
  return self.badgeNumberLabel.text;
}

- (void)setHidden:(BOOL)hidden {
  self.badgeNumberLabel.hidden = hidden;
}

- (BOOL)hidden {
  return self.badgeNumberLabel.hidden;
}

- (void)setBottomIndicatorColor:(UIColor *)bottomIndicatorColor {
  self.bottomIndicatorView.backgroundColor = bottomIndicatorColor;
}

- (UIColor *)bottomIndicatorColor {
  return self.bottomIndicatorView.backgroundColor;
}

- (void)setButtonTag:(NSInteger)buttonTag {
  self.button.tag = buttonTag;
}

- (NSInteger)buttonTag {
  return self.button.tag;
}

- (IBAction)buttonDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate selectActivityLineTitleByTag:sender.tag];
  }
}

@end

