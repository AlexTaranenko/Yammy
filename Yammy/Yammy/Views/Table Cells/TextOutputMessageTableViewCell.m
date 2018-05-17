//
//  TextOutputMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 11/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TextOutputMessageTableViewCell.h"

@interface TextOutputMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusMessageImageView;
@property (weak, nonatomic) IBOutlet UIView *containerNotSendView;

@end

@implementation TextOutputMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.messageImageView.image = [self.messageImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  self.messageImageView.backgroundColor = [UIColor clearColor];
  self.containerNotSendView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareCellByMessageMapping:(MessageMapping *)messageMapping {
  [self prepareMessageByText:messageMapping.Message];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[messageMapping.EventDate doubleValue]];
  [self prepareTimeLabelByText:[Helpers prepareDateFormatterByDate:date andDateFormat:@"HH:mm"]];
  [self changeStatusImageByMessageMapping:messageMapping];
}

- (void)prepareMessageByText:(NSString *)message {
  self.messageLabel.text = message;
}

- (void)prepareTimeLabelByText:(NSString *)time {
  self.timeLabel.text = time;
}

- (void)changeStatusImageByMessageMapping:(MessageMapping *)messageMapping {
  if ([messageMapping.Status integerValue] == STATUS_FAILED) {
    self.containerNotSendView.hidden = NO;
    self.statusMessageImageView.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_SENDING) {
    self.statusMessageImageView.image = [UIImage imageNamed:@"chat_output_sent_one_icon"];
  } else if ([messageMapping.Status integerValue] == STATUS_NEW) {
    self.statusMessageImageView.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_DELIVERED) {
    self.statusMessageImageView.image = [UIImage imageNamed:@"chat_output_delivered_icon"];
  } else {
    self.statusMessageImageView.image = [UIImage imageNamed:@"chat_output_sended_icon"];
  }
}

- (IBAction)resendMessageDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate resendTextMessage:self];
  }
}

@end

