//
//  MotivationYaStarView.m
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationYaStarView.h"

@implementation MotivationYaStarView

+ (MotivationYaStarView *)createMotivationYaStarView {
  MotivationYaStarView *motivationYaStarView = (MotivationYaStarView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationYaStarView" owner:self options:nil] firstObject];
  motivationYaStarView.frame = [UIScreen mainScreen].bounds;
  return motivationYaStarView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)activateYaStarDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showServicesMotivationYaStarView];
  }
}

- (IBAction)closeDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationYaStarView];
  }
}

@end
