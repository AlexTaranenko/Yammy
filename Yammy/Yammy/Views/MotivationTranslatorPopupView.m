//
//  MotivationTranslatorPopupView.m
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationTranslatorPopupView.h"

@implementation MotivationTranslatorPopupView

+ (MotivationTranslatorPopupView *)createMotivationTranslatorPopupView {
  MotivationTranslatorPopupView *motivationTranslatorPopupView = (MotivationTranslatorPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationTranslatorPopupView" owner:self options:nil] firstObject];
  motivationTranslatorPopupView.frame = [UIScreen mainScreen].bounds;
  return motivationTranslatorPopupView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)activateTranslatorDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate activateTranslatorMotivationTranslatorPopupView];
  }
}

- (IBAction)closeDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationTranslatorPopupView];
  }
}

@end
