//
//  VerificationPhotoView.m
//  Yammy
//
//  Created by Alex on 5/15/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "VerificationPhotoView.h"
#import "CornerView.h"

@interface VerificationPhotoView()

@property (weak, nonatomic) IBOutlet CustomImageView *examplePhotoImageView;
@property (weak, nonatomic) IBOutlet CustomImageView *myPhotoImageView;
@property (weak, nonatomic) IBOutlet AutoCornerView *targetView;
@property (weak, nonatomic) IBOutlet UIView *containerButtonsView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) VerifyMapping *verifyMapping;

@end

@implementation VerificationPhotoView

+ (VerificationPhotoView *)createVerificationPhotoView {
  VerificationPhotoView *verificationPhotoView = (VerificationPhotoView *)[[[NSBundle mainBundle] loadNibNamed:@"VerificationPhotoView" owner:self options:nil] firstObject];
  verificationPhotoView.frame = [UIScreen mainScreen].bounds;
  [verificationPhotoView setupTargetView];
  verificationPhotoView.containerButtonsView.hidden = YES;
  verificationPhotoView.isOpenVerify = YES;
  [verificationPhotoView getVerificationFromServer];
  return verificationPhotoView;
}

- (void)getVerificationFromServer {
  [[ServerManager sharedManager] getRequestVerificationsWithCompletion:^(VerifyMapping *verifyMapping, NSString *errorMessage) {
    self.verifyMapping = verifyMapping;
    [self prepareExamplePhotoByMappig:verifyMapping.Image];
  }];
}

- (void)prepareExamplePhotoByMappig:(ImageMapping *)imageMapping {
  NSString *urlPath = imageMapping.Url;
  urlPath = [urlPath substringToIndex:[urlPath length] - 1];
  CGFloat width = self.examplePhotoImageView.frame.size.width * 1.5;
  NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlPath, (long)width, [Helpers getAccessToken]];
  
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [self.examplePhotoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.examplePhotoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.examplePhotoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)presentMyPhotoByImage:(UIImage *)image {
  self.image = image;
  self.myPhotoImageView.image = image;
  self.containerButtonsView.hidden = NO;
}

- (void)setupTargetView {
  self.targetView.borderWidth = @(3);
  self.targetView.borderColor = RGB(204, 204, 204);
  self.targetView.lineCap = kCALineCapSquare;
  self.targetView.lineDashPattern = @[@10];
  self.targetView.backgroundColor = [UIColor clearColor];
  self.targetView.layer.cornerRadius = 10;
}

- (IBAction)openGalleryDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentGalleryVerificationPhotoView];
  }
}

- (IBAction)capturePhotoDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentCameraVerificationPhotoView];
  }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  self.isOpenVerify = NO;
  if (self.delegate != nil) {
    [self.delegate hideVerificationPhotoView];
  }
}

- (IBAction)verifyDidTap:(UIButton *)sender {
  [[ServerManager sharedManager] verifyPhotoByImage:self.image withMapping:self.verifyMapping withCompletion:^(BOOL success, NSString *errorMessage) {
    if (success) {
      self.isOpenVerify = NO;
      if (self.delegate != nil) {
        [self.delegate hideVerificationPhotoView];
        [WToast showWithText:@"Ваша фотография успешно верифицирована" duration:3.0];
      }
    }
  }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
