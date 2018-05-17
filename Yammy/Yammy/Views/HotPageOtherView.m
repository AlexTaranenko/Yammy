//
//  HotPageOtherView.m
//  Yammy
//
//  Created by Alex on 28.10.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HotPageOtherView.h"

@interface HotPageOtherView()

@property (weak, nonatomic) IBOutlet CircularImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mainIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *hotPageOtherButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HotPageOtherView

+ (HotPageOtherView *)prepareHotPageOtherView {
  HotPageOtherView *hotPageOtherView = (HotPageOtherView *)[[[NSBundle mainBundle] loadNibNamed:@"HotPageOtherView" owner:self options:nil] firstObject];
  hotPageOtherView.frame = [UIScreen mainScreen].bounds;
  [hotPageOtherView prepareIconImageViewBorder];
  return hotPageOtherView;
}

#pragma mark - Private

- (void)prepareIconImageViewBorder {
  self.iconImageView.borderWidth = @(1.0);
  self.iconImageView.borderColor = RGB(214, 0, 65);
}

#pragma mark - Public

- (void)prepareMainIconImageByImageName:(NSString *)imageName {
  self.mainIconImageView.image = [UIImage imageNamed:imageName];
}

- (void)prepareOtherButtonWithTitle:(NSString *)title {
  [self.hotPageOtherButton setTitle:title forState:UIControlStateNormal];
}

- (void)prepareTitleLabelByTitle:(NSString *)title {
  self.titleLabel.text = title;
}

#pragma mark - Actions

- (IBAction)hotPageOtherButtonDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate dismissHotPageOtherView];
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
