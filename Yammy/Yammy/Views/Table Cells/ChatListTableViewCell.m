//
//  ChatListTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "MessageMapping.h"

@interface ChatListTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CircularImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusMessageIconImageView;
@property (weak, nonatomic) IBOutlet CustomLabel *countMessagesLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStatusMessageWidth;
@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;

@property (strong, nonatomic) ChatMapping *chatMapping;

@end

@implementation ChatListTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.layoutStatusMessageWidth.constant = 16.0;
  self.statusImageView.borderWidth = @(2.0);
  self.statusImageView.borderColor = RGB(250, 250, 250);
  [self hiddenStatusImageView:YES];
  [self hiddenStatusMessageIconImageView:YES];
  [self hiddenStatusMessageIconImageView:YES];
  [self hiddenLockImageView:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareFromMessageByChatMapping:(ChatMapping *)chatMapping {
  self.chatMapping = chatMapping;
  [self prepareTimeWithNameLabelsByChatMapping:chatMapping];
  self.messageLabel.text = chatMapping.SubTitle;
  
  if ([chatMapping.OpponentIsOnline boolValue]) {
    [self hiddenStatusImageView:NO];
  }
  
  if ([chatMapping.IsBlocked boolValue]) {
    [self hiddenLockImageView:NO];
  }
  
  [self preparePhotoImageViewByUrlString:chatMapping.OpponentUserPhoto.Url andImageView:self.photoImageView];
  [self prepareCountMessagesByChatMapping:chatMapping];
}

- (void)prepareToMessageByChatMapping:(ChatMapping *)chatMapping {
  self.chatMapping = chatMapping;
  [self prepareTimeWithNameLabelsByChatMapping:chatMapping];
  self.messageLabel.text = chatMapping.SubTitle;
  if (chatMapping.IsIncoming != nil && [chatMapping.IsIncoming boolValue] == true) {
    self.layoutStatusMessageWidth.constant = 0;
  } else {
    [self checkStatusMessageByChatMapping:chatMapping];
  }
  [self preparePhotoImageViewByUrlString:chatMapping.OpponentUserPhoto.Url andImageView:self.photoImageView];
  
  if ([chatMapping.OpponentIsOnline boolValue]) {
    [self hiddenStatusImageView:NO];
  }
  
  if ([chatMapping.IsBlocked boolValue]) {
    [self hiddenLockImageView:NO];
  }
  
  [self prepareCountMessagesByChatMapping:chatMapping];
}

- (void)prepareCountMessagesByChatMapping:(ChatMapping *)chatMapping {
  if (chatMapping.UnSeen != nil && [chatMapping.UnSeen integerValue] > 0) {
    self.countMessagesLabel.hidden = NO;
    self.countMessagesLabel.text = [NSString stringWithFormat:@"%ld", [chatMapping.UnSeen integerValue]];
  } else {
    self.countMessagesLabel.hidden = YES;
  }
}

- (void)prepareTimeWithNameLabelsByChatMapping:(ChatMapping *)chatMapping {
  NSDate *time = [NSDate dateWithTimeIntervalSince1970:[chatMapping.EventDate doubleValue]];
  self.timeLabel.text = [Helpers prepareDateFormatterByDate:time andDateFormat:@"HH:mm"];
  self.nameLabel.text = chatMapping.Title;
}

- (void)preparePhotoImageViewByUrlString:(NSString *)urlPath andImageView:(UIImageView *)imgView {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = imgView.frame.size.width * 2;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [imgView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        imgView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    imgView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)checkStatusMessageByChatMapping:(ChatMapping *)chatMapping {
  
  [self hiddenStatusMessageIconImageView:NO];
  if ([chatMapping.ChatStatus integerValue] == STATUS_NEW) {
    [self changeStatusMessageIconImageByImageName:@""];
    self.layoutStatusMessageWidth.constant = 0;
  } else if ([chatMapping.ChatStatus integerValue] == STATUS_SENDING) {
    [self changeStatusMessageIconImageByImageName:@"chat_list_sent_one_icon"];
  } else if ([chatMapping.ChatStatus integerValue] == STATUS_DELIVERED) {
    [self changeStatusMessageIconImageByImageName:@"chat_list_sent_icon"];
  } else if ([chatMapping.ChatStatus integerValue] == STATUS_READ) {
    [self changeStatusMessageIconImageByImageName:@"chat_list_sended_icon"];
  }
}

- (void)hiddenStatusImageView:(BOOL)hidden {
  self.statusImageView.hidden = hidden;
}

- (void)hiddenStatusMessageIconImageView:(BOOL)hidden {
  self.statusMessageIconImageView.hidden = hidden;
}

- (void)changeStatusMessageIconImageByImageName:(NSString *)imageName {
  self.statusMessageIconImageView.image = [UIImage imageNamed:imageName];
}

- (void)hiddenLockImageView:(BOOL)hidden {
  self.lockImageView.hidden = hidden;
}

@end

