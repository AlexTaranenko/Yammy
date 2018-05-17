//
//  YaMaxView.m
//  Yammy
//
//  Created by Alex on 10/30/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "YaMaxView.h"

@interface YaMaxView()

@end

@implementation YaMaxView

+ (YaMaxView *)createYaMaxView {
  YaMaxView *yaMaxView = (YaMaxView *)[[[NSBundle mainBundle] loadNibNamed:@"YaMaxView" owner:self options:nil] firstObject];
  yaMaxView.frame = [UIScreen mainScreen].bounds;
  return yaMaxView;
}

- (IBAction)yaMaxDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate dismissYaMaxView];
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

