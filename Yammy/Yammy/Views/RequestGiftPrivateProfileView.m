//
//  RequestGiftPrivateProfileView.m
//  Yammy
//
//  Created by Alex on 5/5/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "RequestGiftPrivateProfileView.h"

@interface RequestGiftPrivateProfileView()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;

@end

@implementation RequestGiftPrivateProfileView

+ (RequestGiftPrivateProfileView *)createRequestGiftPrivateProfileView {
  RequestGiftPrivateProfileView *requestGiftPrivateProfileView = (RequestGiftPrivateProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"RequestGiftPrivateProfileView" owner:self options:nil] firstObject];
  requestGiftPrivateProfileView.frame = [UIScreen mainScreen].bounds;
  return requestGiftPrivateProfileView;
}

- (void)prepareInterfaceByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  [self prepareInterfaceByProfileMapping:activityLineMapping.FromUser];
  self.subTitleLabel.text = activityLineMapping.SubTitle;
  self.descriptionLabel.text = activityLineMapping.Description;
  [self prepareGiftImageByGiftMapping:activityLineMapping.Gift];
}

- (void)prepareInterfaceByProfileMapping:(ProfileMapping *)profileMapping {
  NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:[profileMapping.BirthDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdayDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  self.nameLabel.text = [NSString stringWithFormat:@"%@, %ld", profileMapping.FirstName ?: @"", (long)[components year]];
  [self preparePhotoByProfileMapping:profileMapping];
}

- (void)preparePhotoByProfileMapping:(ProfileMapping *)profileMapping {
  if (profileMapping.PrimaryPhoto != nil) {
    [self downloadPhotoWithImage:self.photoImageView withUrlPath:profileMapping.PrimaryPhoto.Url];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)prepareGiftImageByGiftMapping:(GiftMapping *)giftMapping {
  [self downloadPhotoWithImage:self.giftImageView withUrlPath:giftMapping.Image.Url];
}

- (void)downloadPhotoWithImage:(UIImageView *)customImageView withUrlPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = customImageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [customImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        customImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    customImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelRequestGift:sender];
  }
}

- (IBAction)acceptDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate acceptRequestGift:sender];
  }

}

@end
