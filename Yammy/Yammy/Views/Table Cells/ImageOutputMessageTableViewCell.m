//
//  ImageOutputMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 12/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ImageOutputMessageTableViewCell.h"

@interface ImageOutputMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusMessage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *containerNotSendView;

@property (strong, nonatomic) MessageMapping *messageMapping;

@end

@implementation ImageOutputMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.messageImageView.image = [self.messageImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
  self.containerNotSendView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareImageOutputMessageByMessageMapping:(MessageMapping *)messageMapping {
  self.messageMapping = messageMapping;
  self.dateLabel.text = [self dateStringFromTimeInterval:messageMapping.EventDate];
  [self changeStatusImageByMessageMapping:messageMapping];
  [self setupImageOutputGesture];
  self.messageLabel.text = messageMapping.SubTitle;
  
  NSString *urlPath = messageMapping.Image.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.photoImageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [self.photoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
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

- (void)changeStatusImageByMessageMapping:(MessageMapping *)messageMapping {
  if ([messageMapping.Status integerValue] == STATUS_FAILED) {
    self.containerNotSendView.hidden = NO;
    self.statusMessage.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_SENDING) {
    self.statusMessage.image = [UIImage imageNamed:@"chat_output_sent_one_icon"];
  } else if ([messageMapping.Status integerValue] == STATUS_NEW) {
    self.statusMessage.image = [UIImage imageNamed:@""];
  } else if ([messageMapping.Status integerValue] == STATUS_DELIVERED) {
    self.statusMessage.image = [UIImage imageNamed:@"chat_output_delivered_icon"];
  } else {
    self.statusMessage.image = [UIImage imageNamed:@"chat_output_sended_icon"];
  }
}

- (void)setupImageOutputGesture {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImage)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [self.messageImageView addGestureRecognizer:tapGestureRecognizer];
  self.messageImageView.userInteractionEnabled = YES;
}

- (void)showFullImage {
  if (self.delegate != nil) {
    [self.delegate showImageOutputMessageByMessageMapping:self.messageMapping];
  }
}

- (IBAction)resendDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate resendImageMessage];
  }
}

@end

