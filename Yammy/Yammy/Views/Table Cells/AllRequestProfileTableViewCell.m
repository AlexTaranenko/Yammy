//
//  AllRequestProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 4/12/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "AllRequestProfileTableViewCell.h"

@interface AllRequestProfileTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *acceptContainerView;
@property (weak, nonatomic) IBOutlet UIView *giftContainerView;
@property (weak, nonatomic) IBOutlet UIView *messageContainerView;

@end

@implementation AllRequestProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.acceptContainerView.hidden = YES;
  self.giftContainerView.hidden = YES;
  self.messageContainerView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllRequestProfileByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.titleLabel.text = activityLineMapping.Title;
  self.descriptionLabel.text = activityLineMapping.SubTitle;
  
  [self preparePhoroImageByImageView:self.photoImageView andProfileMapping:activityLineMapping.FromUser];
  [self prepareHasPrivateProfile:activityLineMapping];
  
  if ([activityLineMapping.EventType integerValue] == RejectedAccessToPrivateProfile) {
    self.giftContainerView.hidden = NO;
    [self prepareIconImage:@"activity_line_block"];
  } else if ([activityLineMapping.EventType integerValue] == RejectedAccessForGiftToPrivateProfile) {
    self.messageContainerView.hidden = NO;
    [self prepareIconImage:@"activity_line_block"];
  } else if ([activityLineMapping.EventType integerValue] == RequestedExchangePrivateProfile) {
    self.acceptContainerView.hidden = NO;
    [self prepareIconImage:@"activity_line_refresh"];
  } else if ([activityLineMapping.EventType integerValue] == RejectedExchangePrivateProfile) {
    self.messageContainerView.hidden = NO;
    [self prepareIconImage:@"activity_line_block"];
  } else {
    [self prepareIconImage:@"has_private_profile_icon"];
  }
}

- (void)prepareHasPrivateProfile:(ActivityLineMapping *)activityLineMapping {
  if ([activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
    [self prepareBorder:self.borderImageView width:3.0 color:RGB(249, 0, 64)];
    [self prepareBorder:self.photoImageView width:2.0 color:RGB(250, 250, 250)];
    [self prepareBorder:self.iconImageView width:2.0 color:RGB(250, 250, 250)];
  } else {
    [self prepareBorder:self.borderImageView width:0.0 color:[UIColor clearColor]];
    [self prepareBorder:self.photoImageView width:0.0 color:[UIColor clearColor]];
    [self prepareBorder:self.iconImageView width:0.0 color:[UIColor clearColor]];
  }
}

- (void)prepareBorder:(CustomImageView *)imageView width:(CGFloat)width color:(UIColor *)color {
  imageView.borderWidth = width;
  imageView.borderColor = color;
}

- (void)prepareIconImage:(NSString *)imageName {
  self.iconImageView.image = [UIImage imageNamed:imageName];
}

- (void)preparePhoroImageByImageView:(CustomImageView *)circularImageView andProfileMapping:(ProfileMapping *)profileMapping {
  NSURL *urlImage = [self urlImageByProfileMapping:profileMapping];
  if (urlImage) {
    [circularImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        circularImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    circularImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (NSURL *)urlImageByProfileMapping:(ProfileMapping *)profileMapping {
  NSString *urlPath = profileMapping.PrimaryPhoto.Url;
  if (urlPath) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = self.photoImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

- (IBAction)showProfileDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showProfile:self];
  }
}

- (IBAction)acceptCancelDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelRequest:self];
  }
}

- (IBAction)acceptSuccessDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate acceptRequest:self];
  }
}

- (IBAction)giftCancelDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelRequest:self];
  }
}

- (IBAction)giftSendDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showGifts:self];
  }
}

- (IBAction)chatCancelDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelRequest:self];
  }
}

- (IBAction)chatShowDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showChat:self];
  }
}

@end
