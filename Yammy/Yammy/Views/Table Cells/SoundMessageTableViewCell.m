//
//  SoundMessageTableViewCell.m
//  Yammy
//
//  Created by Paul Yevchenko on 27/12/2017.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SoundMessageTableViewCell.h"
#import "SoundOutputMessageTableViewCell.h"
#import "AudioManager.h"

@implementation SoundMessageTableViewCell
{
  MessageMapping *_messageMapping;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.messageImageView.image = [self.messageImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareSoundMessageCellByMessageMapping:(MessageMapping *)messageMapping isOutgoing:(BOOL)outgoing {
  _messageMapping = messageMapping;
  
  self.playButton.selected = NO;
  self.progressView.progress = 0.0;
  self.endTimeLabel.text = [self dateStringFromTimeInterval:messageMapping.EventDate];
}

- (NSString *)prepareTimeLabelByTimeInterval:(NSTimeInterval)interval {
  NSInteger minute = [[self dateComponentsFromTime:interval] minute];
  NSInteger second = [[self dateComponentsFromTime:interval] second];
  NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
  return durationString;
}

- (NSString *)dateStringFromTimeInterval:(NSNumber *)eventDate {
  if (eventDate != nil) {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[eventDate integerValue]];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"HH:mm";
    return [dateFormatter stringFromDate:date];
  } else {
    return @"--:--";
  }
}

- (NSDateComponents *)dateComponentsFromTime:(NSTimeInterval)timeInterval {
  unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
  NSDate *fromDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
  NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:unitFlags fromDate:fromDate];
  return dateComponents;
}

- (IBAction)playDidTap:(UIButton *)sender {
  NSString *audioUrlString = [NSString stringWithFormat:@"%@%@?Token=%@", MAIN_URL, _messageMapping.Audio.Url, [Helpers getAccessToken]];
  [[AudioManager sharedManager] playAudioFromUrl:audioUrlString withCompletion:^(NSTimeInterval currentTime, NSTimeInterval durationTime, BOOL status) {
    self.playButton.selected = !status;
    self.progressView.progress = currentTime / durationTime;
  }];
}



@end

