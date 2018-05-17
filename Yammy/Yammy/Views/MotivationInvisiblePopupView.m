//
//  MotivationInvisiblePopupView.m
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationInvisiblePopupView.h"

@implementation MotivationInvisiblePopupView

+ (MotivationInvisiblePopupView *)createMotivationInvisiblePopupView {
  MotivationInvisiblePopupView *motivationInvisiblePopupView = (MotivationInvisiblePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationInvisiblePopupView" owner:self options:nil] firstObject];
  motivationInvisiblePopupView.frame = [UIScreen mainScreen].bounds;
  return motivationInvisiblePopupView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)activateInvisibleDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate activateInvisibleMotivationInvisiblePopupView];
  }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationInvisiblePopupView];
  }
}

@end
