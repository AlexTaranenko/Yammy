//
//  MotivationPrivateProfilePopupView.m
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationMatchProfilePopupView.h"

@interface MotivationMatchProfilePopupView()

@property (weak, nonatomic) IBOutlet CustomImageView *fromImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *toImageView;

@property (strong, nonatomic) MatchMapping *matchMapping;

@end

@implementation MotivationMatchProfilePopupView

+ (MotivationMatchProfilePopupView *)createMotivationPrivateProfilePopupView {
  MotivationMatchProfilePopupView *motivationPrivateProfilePopupView = (MotivationMatchProfilePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationMatchProfilePopupView" owner:self options:nil] firstObject];
  motivationPrivateProfilePopupView.frame = [UIScreen mainScreen].bounds;
  [motivationPrivateProfilePopupView rotateImageView];
  return motivationPrivateProfilePopupView;
}

- (void)rotateImageView {
  self.fromImageView.transform = CGAffineTransformMakeRotation(-15 * M_PI/180);
  self.toImageView.transform = CGAffineTransformMakeRotation(15 * M_PI/180);
}

- (void)prepareInterfaceByMatchMapping:(MatchMapping *)matchMapping {
  self.matchMapping = matchMapping;
  [self preparePhoroImageByImageView:self.fromImageView andProfileMapping:matchMapping.FromUser];
  [self preparePhoroImageByImageView:self.toImageView andProfileMapping:matchMapping.ToUser];
}

- (void)preparePhoroImageByImageView:(CustomImageView *)customImageView andProfileMapping:(ProfileMapping *)profileMapping {
  NSURL *urlImage = [self urlImageByProfileMapping:profileMapping customImageView:customImageView];
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

- (NSURL *)urlImageByProfileMapping:(ProfileMapping *)profileMapping customImageView:(CustomImageView *)customImageView {
  NSString *urlPath = profileMapping.PrimaryPhoto.Url;
  if (urlPath) {
    urlPath = [urlPath substringToIndex:[urlPath length] - 1];
    CGFloat width = customImageView.frame.size.width * 1.8;
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
    NSURL *urlImage = [NSURL URLWithString:urlString];
    return urlImage;
  }
  return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)openChatDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openChatMotivationMatchProfilePopup:self.matchMapping];
  }
}

- (IBAction)closeDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationMatchProfilePopup];
  }
}

@end
