//
//  ImageInputMessageTableViewCell.m
//  Yammy
//
//  Created by Alex on 12/11/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ImageInputMessageTableViewCell.h"

@interface ImageInputMessageTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *messasgeImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) MessageMapping *messageMapping;

@end

@implementation ImageInputMessageTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.messasgeImageView.image = [self.messasgeImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareImageInputMessageByMessageMapping:(MessageMapping *)messageMapping {
  self.messageMapping = messageMapping;
  [self setupImageInputGesture];
  self.messageLabel.text = messageMapping.SubTitle;
  self.timeLabel.text = [self dateStringFromTimeInterval:messageMapping.EventDate];
  
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

- (void)setupImageInputGesture {
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullImage)];
  tapGestureRecognizer.numberOfTapsRequired = 1;
  [self.messasgeImageView addGestureRecognizer:tapGestureRecognizer];
  self.messasgeImageView.userInteractionEnabled = YES;
}

- (void)showFullImage {
  if (self.delegate != nil) {
    [self.delegate showImageInputMessageByMessageMapping:self.messageMapping];
  }
}

@end

