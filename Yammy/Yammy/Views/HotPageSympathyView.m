//
//  HotPageSympathyView.m
//  Yammy
//
//  Created by Alex on 10/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HotPageSympathyView.h"

@interface HotPageSympathyView()

@property (weak, nonatomic) IBOutlet CircularImageView *fromPhotoImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *toPhotoImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *fromSexImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *toSexImageView;

@property (weak, nonatomic) IBOutlet UILabel *fromNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *toNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;

@end

@implementation HotPageSympathyView

+ (HotPageSympathyView *)prepareHotPageSympathyView {
  HotPageSympathyView *hotPageSympathyView = (HotPageSympathyView *)[[[NSBundle mainBundle] loadNibNamed:@"HotPageSympathyView" owner:self options:nil] firstObject];
  hotPageSympathyView.frame = [UIScreen mainScreen].bounds;
  [hotPageSympathyView prepareSendMessageButton];
  [hotPageSympathyView prepareLabels];
  return hotPageSympathyView;
}

- (void)prepareSendMessageButton {
  self.sendMessageButton.layer.cornerRadius = 3.0f;
  self.sendMessageButton.clipsToBounds = YES;
}

- (void)prepareLabels {
  self.fromNameLabel.text = @"Александра\n21";
  self.toNameLabel.text = @"Геннадий\n46";
}

- (IBAction)openChatDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate pushToChat];
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

