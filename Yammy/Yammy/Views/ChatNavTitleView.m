//
//  ChatNavTitleView.m
//  Yammy
//
//  Created by Alex on 02.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ChatNavTitleView.h"

@interface ChatNavTitleView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ChatNavTitleView

+ (ChatNavTitleView *)createChatNavTitleView {
  ChatNavTitleView *chatNavTitleView = (ChatNavTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"ChatNavTitleView" owner:self options:nil] firstObject];
  
  NSLayoutConstraint * widthConstraint = [chatNavTitleView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width - 100.f];
  NSLayoutConstraint * HeightConstraint = [chatNavTitleView.heightAnchor constraintEqualToConstant:40];
  [widthConstraint setActive:YES];
  [HeightConstraint setActive:YES];
  
  return chatNavTitleView;
}

- (void)prepareChatNavTitleViewByProfileMapping:(ProfileMapping *)profileMapping {
  self.nameLabel.text = profileMapping.FirstName;
  self.statusLabel.text = profileMapping.IsOnline != nil && [profileMapping.IsOnline boolValue] ? @"Онлайн" : @"Офлайн";
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

