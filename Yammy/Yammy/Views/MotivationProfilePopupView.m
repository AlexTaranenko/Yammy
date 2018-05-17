//
//  MotivationProfilePopupView.m
//  Yammy
//
//  Created by Alex on 5/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationProfilePopupView.h"
#import "CornerView.h"

@interface MotivationProfilePopupView()

@property (weak, nonatomic) IBOutlet AutoCornerView *targetView;

@end

@implementation MotivationProfilePopupView

+ (MotivationProfilePopupView *)createMotivationProfilePopupView:(NSString *)nibName {
  MotivationProfilePopupView *motivationProfilePopupView = (MotivationProfilePopupView *)[[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] firstObject];
  motivationProfilePopupView.frame = [UIScreen mainScreen].bounds;
  [motivationProfilePopupView setupTargetView];
  return motivationProfilePopupView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupTargetView {
  self.targetView.borderWidth = @(2);
  self.targetView.borderColor = RGB(204, 204, 204);
  self.targetView.lineCap = kCALineCapSquare;
  self.targetView.lineDashPattern = @[@3, @5];
  self.targetView.backgroundColor = [UIColor clearColor];
  self.targetView.layer.cornerRadius = 10;
}


- (IBAction)showProfileDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate showMotivationProfilePopupMyProfile];
  }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationProfilePopup];
  }
}

- (IBAction)selePhotoDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openMotivationProfilePopupGallery];
  }
}

- (IBAction)capturePhotoDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openMotivationProfilePopupCamera];
  }
}

@end
