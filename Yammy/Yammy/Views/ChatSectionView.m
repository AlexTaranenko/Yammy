//
//  ChatSectionView.m
//  Yammy
//
//  Created by Alex on 2/15/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ChatSectionView.h"

@interface ChatSectionView()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ChatSectionView

+ (ChatSectionView *)setupChatSectionView {
  return (ChatSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"ChatSectionView" owner:self options:nil] firstObject];
}

- (void)prepareTimeLabelByDate:(NSDate *)date {
  if ([[NSCalendar currentCalendar] isDateInToday:date]) {
    self.dateLabel.text = @"Сегодня";
  } else {
    self.dateLabel.text = [Helpers prepareDateFormatterByDate:date andDateFormat:@"dd MMMM"];
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

