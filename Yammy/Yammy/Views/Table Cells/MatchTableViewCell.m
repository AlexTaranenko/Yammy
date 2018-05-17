//
//  MatchTableViewCell.m
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MatchTableViewCell.h"

@interface MatchTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *fromPhotoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *toPhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@end

@implementation MatchTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareMatchCellByMapping:(MatchMapping *)matchMapping {
  self.titleLabel.text = matchMapping.Title;
  self.messageLabel.text = matchMapping.SubTitle;
  [self rotationImages];
  [self preparePhoroImageByImageView:self.fromPhotoImageView andProfileMapping:matchMapping.FromUser];
  [self preparePhoroImageByImageView:self.toPhotoImageView andProfileMapping:matchMapping.ToUser];
}

- (void)prepareMatchCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.titleLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
  [self rotationImages];
  [self preparePhoroImageByImageView:self.fromPhotoImageView andProfileMapping:activityLineMapping.FromUser];
  [self preparePhoroImageByImageView:self.toPhotoImageView andProfileMapping:[ServerManager sharedManager].myProfileMapping];
}

- (void)rotationImages {
  self.fromPhotoImageView.transform = CGAffineTransformMakeRotation(-15 * M_PI/180);
  self.toPhotoImageView.transform = CGAffineTransformMakeRotation(15 * M_PI/180);
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMatchPublicProfile)];
  [self.toPhotoImageView addGestureRecognizer:gesture];
  self.toPhotoImageView.userInteractionEnabled = YES;
}

- (NSString *)prepareNameByProfileMapping:(ProfileMapping *)profileMapping {
  NSString *name = profileMapping.FirstName;
  NSDate *birthdayDate = [NSDate dateWithTimeIntervalSince1970:[profileMapping.BirthDate doubleValue]];
  NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:birthdayDate toDate:[NSDate date] options:0];
  [components setTimeZone:[NSTimeZone defaultTimeZone]];
  return [NSString stringWithFormat:@"%@\n%ld", name, (long)[components year]];
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
    CGFloat width = self.fromPhotoImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

- (IBAction)openChatDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openMatchChatByCell:self];
  }
}

- (void)openMatchPublicProfile {
  if (self.delegate != nil) {
    [self.delegate openMatchPublicProfileByCell:self];
  }
}

@end

