//
//  TextInputMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 03.11.2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TextInputMessageTableViewCell.h"

@interface TextInputMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TextInputMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.messageImageView.image = [self.messageImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareCellByMessageMapping:(MessageMapping *)messageMapping {
  [self prepareMessageByText:messageMapping.Message];
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:[messageMapping.EventDate doubleValue]];
  [self prepareTimeLabelByTime:[Helpers prepareDateFormatterByDate:date andDateFormat:@"HH:mm"]];
}

- (void)prepareMessageByText:(NSString *)message {
  self.messageLabel.text = message;
}

- (void)prepareTimeLabelByTime:(NSString *)time {
  self.timeLabel.text = time;
}

@end

