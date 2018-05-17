//
//  PublicProfileGiftsTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PublicProfileGiftsTableViewCell.h"

@interface PublicProfileGiftsTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *whoNameLabel;
@property (weak, nonatomic) IBOutlet CustomButton *makeGiftButton;
@property (weak, nonatomic) IBOutlet CustomImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *profileContainerView;

@property (strong, nonatomic) ProfileMapping *fromUser;

@end

@implementation PublicProfileGiftsTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)preparePublicProfileGiftsCell:(MyGiftMapping *)myGiftMapping {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openProfile)];
  [self.profileContainerView addGestureRecognizer:tap];
  self.profileContainerView.userInteractionEnabled = YES;

  self.fromUser = myGiftMapping.FromUser;
  
  self.nameLabel.text = [self prepareNameByProfileMapping:myGiftMapping.FromUser];
  self.whoNameLabel.text = myGiftMapping.SubTitle;
  [self prepareImageByMapping:myGiftMapping];
  [self prepareUserPhotoImageByProfileMapping:myGiftMapping.FromUser];
  [self prepareTimeLabelByMapping:myGiftMapping];
  
  if (myGiftMapping.Title.length == 0) {
    self.makeGiftButton.hidden = YES;
  } else {
    self.makeGiftButton.hidden = NO;
    [self.makeGiftButton setTitle:myGiftMapping.Title forState:UIControlStateNormal];
  }
}

- (NSString *)prepareNameByProfileMapping:(ProfileMapping *)profileMapping {
  NSString *name = profileMapping.FirstName;
  NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:[profileMapping.BirthDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdayDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  return [NSString stringWithFormat:@"%@, %ld", name, (long)[components year]];
}


- (void)prepareTimeLabelByMapping:(MyGiftMapping *)myGiftMapping {
  NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[myGiftMapping.EventDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitYear fromDate:eventDate toDate:[NSDate date] options:NSCalendarWrapComponents];
  
  NSString *dayText;
  if ([components year] > 0) {
    self.dateLabel.text = [[self dateFormatterByFormat:@"dd MMM yyyy"] stringFromDate:eventDate];
  } else {
    if ([components day] == 0) {
      dayText = @"сегодня";
    } else if ([components day] == 1) {
      dayText = @"вчера";
    } else {
      dayText = [[self dateFormatterByFormat:@"dd MMM"] stringFromDate:eventDate];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ в %@", dayText, [[self dateFormatterByFormat:@"HH:mm"] stringFromDate:eventDate]];
  }
}

- (NSDateFormatter *)dateFormatterByFormat:(NSString *)format {
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  dateFormatter.dateFormat = format;
  return dateFormatter;
}
- (void)prepareUserPhotoImageByProfileMapping:(ProfileMapping *)profileMapping {
  NSString *urlPath = profileMapping.PrimaryPhoto.Url;
  [self prepareImageByImageView:self.userPhotoImageView andWidthImage:self.userPhotoImageView.frame.size.width andPath:urlPath];
}

- (void)prepareImageByMapping:(MyGiftMapping *)myGiftMapping {
  NSString *urlPath = myGiftMapping.Gift.Image.Url;
  [self prepareImageByImageView:self.giftImageView andWidthImage:self.giftImageView.frame.size.width * 1.5 andPath:urlPath];
}

- (void)prepareImageByImageView:(UIImageView *)imgView andWidthImage:(CGFloat)widthImage andPath:(NSString *)urlPath {
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = widthImage;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  NSURL *url = [NSURL URLWithString:urlString];
  if (url) {
    [imgView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        imgView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    imgView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)openProfile {
  if (self.delegate != nil) {
    [self.delegate presentProfileByMapping:self.fromUser];
  }
}

- (IBAction)makeGiftDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentGiftsWithProfile:self.fromUser];
  }
}

@end

