//
//  TabBarView.m
//  Yammy
//
//  Created by Alex on 2/23/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "TabBarView.h"

@implementation TabBarView

+ (TabBarView *)createTabBarView {
  return (TabBarView *)[[[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil] firstObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
