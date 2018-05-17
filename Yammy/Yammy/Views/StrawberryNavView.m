//
//  StrawberryNavView.m
//  Yammy
//
//  Created by Alex on 26.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "StrawberryNavView.h"

@interface StrawberryNavView()

@end

@implementation StrawberryNavView

+ (StrawberryNavView *)setupStrawberryNavView {
  StrawberryNavView *strawberryNavView = (StrawberryNavView *)[[[NSBundle mainBundle] loadNibNamed:@"StrawberryNavView" owner:self options:nil] firstObject];
  return strawberryNavView;
}

- (IBAction)presentPrivateProfileDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate changePublicToPrivateVC];
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

