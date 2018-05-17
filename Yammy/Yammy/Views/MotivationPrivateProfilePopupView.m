//
//  MotivationPrivateProfilePopupView.m
//  Yammy
//
//  Created by Alex on 5/8/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationPrivateProfilePopupView.h"
#import "Yammy-Swift.h"

@interface MotivationPrivateProfilePopupView()<OnlyPicturesDataSource, OnlyPicturesDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerPreferencesView;

@property (strong, nonatomic) OnlyHorizontalPictures *onlyPictures;

@end

@implementation MotivationPrivateProfilePopupView

- (OnlyHorizontalPictures *)onlyPictures {
  if (_onlyPictures == nil) {
    _onlyPictures = [[OnlyHorizontalPictures alloc] initWithFrame:CGRectMake(0, 0, self.containerPreferencesView.frame.size.width, self.containerPreferencesView.frame.size.height)];
    _onlyPictures.dataSource = self;
    _onlyPictures.delegate = self;
    _onlyPictures.backgroundColor = [UIColor clearColor];
    _onlyPictures.spacingColor = RGB(250, 250, 250);
    _onlyPictures.spacing = 4.0;
    _onlyPictures.gap = 36;
    
    _onlyPictures.layer.cornerRadius = 20.0;
    _onlyPictures.layer.masksToBounds = YES;
  }
  
  return _onlyPictures;
}

+ (MotivationPrivateProfilePopupView *)createMotivationPrivateProfilePopupView {
  MotivationPrivateProfilePopupView *motivationPrivateProfilePopupView = (MotivationPrivateProfilePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationPrivateProfilePopupView" owner:self options:nil] firstObject];
  motivationPrivateProfilePopupView.frame = [UIScreen mainScreen].bounds;
  [motivationPrivateProfilePopupView.containerPreferencesView addSubview:motivationPrivateProfilePopupView.onlyPictures];
  return motivationPrivateProfilePopupView;
}

- (NSInteger)numberOfPictures {
  return 5;
}

- (NSInteger)visiblePictures {
  return 5;
}

- (void)pictureViews:(UIImageView *)imageView index:(NSInteger)index {
  imageView.image = [UIImage imageNamed:@"preferences_placeholder_icon"];
}

- (void)pictureView:(UIImageView *)imageView didSelectAt:(NSInteger)index {
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)showPrivateProfileDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openPrivateProfileMotivationPrivateProfilePopup];
  }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationPrivateProfilePopup];
  }
}

@end
