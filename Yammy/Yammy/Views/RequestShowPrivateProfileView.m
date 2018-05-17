//
//  RequestShowPrivateProfileView.m
//  Yammy
//
//  Created by Alex on 4/26/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "RequestShowPrivateProfileView.h"

@interface RequestShowPrivateProfileView()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet CustomImageView *borderImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet CustomButton *requestButton;

@end

@implementation RequestShowPrivateProfileView

+ (RequestShowPrivateProfileView *)createRequestShowPrivateProfileView {
  RequestShowPrivateProfileView *requestShowPrivateProfileView = (RequestShowPrivateProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"RequestShowPrivateProfileView" owner:self options:nil] firstObject];
  requestShowPrivateProfileView.frame = [UIScreen mainScreen].bounds;
  [requestShowPrivateProfileView hasPrivateProfile:NO];
  [requestShowPrivateProfileView prepareImage:requestShowPrivateProfileView.photoImageView borderColor:RGB(250, 250, 250) borderWidth:2];
  return requestShowPrivateProfileView;
}

- (void)prepareInterfaceByProfileMapping:(ProfileMapping *)profileMapping {
  NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:[profileMapping.BirthDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdayDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  self.nameLabel.text = [NSString stringWithFormat:@"%@, %ld", profileMapping.FirstName ?: @"", (long)[components year]];
  [self preparePhotoByProfileMapping:profileMapping];
}

- (void)prepareInterfaceByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  [self prepareInterfaceByProfileMapping:activityLineMapping.FromUser];
  if ([activityLineMapping.FromUser.HasPrivateProfile boolValue]) {
    [self hasPrivateProfile:YES];
    [self prepareImage:self.borderImageView borderColor:RGB(249, 0, 64) borderWidth:3];
  }
  
  self.subTitleLabel.text = activityLineMapping.SubTitle;
  self.descriptionLabel.text = activityLineMapping.Description;
}

- (void)preparePhotoByProfileMapping:(ProfileMapping *)profileMapping {
  if (profileMapping.PrimaryPhoto != nil) {
    NSString *urlPath = profileMapping.PrimaryPhoto.Url;
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
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)prepareImage:(CustomImageView *)imageView borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
  imageView.borderColor= borderColor;
  imageView.borderWidth = borderWidth;
}

- (void)hasPrivateProfile:(BOOL)isHas {
  self.borderImageView.hidden = !isHas;
  self.iconImageView.hidden = !isHas;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (IBAction)showGiftDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showGiftsScreen:sender];
  }
}

- (IBAction)cancelDidtap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate cancelSendRequest:sender];
  }
}

- (IBAction)sendDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate sendRequestProfile:sender];
  }
}



@end
