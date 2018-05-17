//
//  SoundOutputMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 11/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SoundOutputMessageTableViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface SoundOutputMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *statusSendImageView;
@property (weak, nonatomic) IBOutlet UIView *containerNotSendView;

@end

@implementation SoundOutputMessageTableViewCell

- (void)changeStatusImageByMessageMapping:(MessageMapping *)messageMapping {
  
  self.containerNotSendView.hidden = YES;
  if ([messageMapping.Status integerValue] == STATUS_FAILED) {
    self.containerNotSendView.hidden = NO;
    self.statusSendImageView.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_SENDING) {
    self.statusSendImageView.image = [UIImage imageNamed:@"chat_output_sent_one_icon"];
  } else if ([messageMapping.Status integerValue] == STATUS_NEW) {
    self.statusSendImageView.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_DELIVERED) {
    self.statusSendImageView.image = [UIImage imageNamed:@"chat_output_delivered_icon"];
  } else {
    self.statusSendImageView.image = [UIImage imageNamed:@"chat_output_sended_icon"];
  }
}

- (IBAction)resendDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate resendSoundMessage];
  }
}

@end

