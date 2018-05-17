//
//  ProfileLeftNavButtonView.m
//  Yammy
//
//  Created by Alex on 2/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "SettingsButtonView.h"

@implementation SettingsButtonView

+ (SettingsButtonView *)setupSettingsButtonView {
  SettingsButtonView *settingsButtonView = (SettingsButtonView *)[[[NSBundle mainBundle] loadNibNamed:@"SettingsButtonView" owner:self options:nil] firstObject];
  return settingsButtonView;
}

- (IBAction)settingDidtap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showSettingsController];
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
