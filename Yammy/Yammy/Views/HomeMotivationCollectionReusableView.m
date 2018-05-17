//
//  HomeMotivationCollectionReusableView.m
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HomeMotivationCollectionReusableView.h"
#import "CornerView.h"

@interface HomeMotivationCollectionReusableView()

@property (weak, nonatomic) IBOutlet AutoCornerView *targetView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *containerWithTwoButtons;

@end

@implementation HomeMotivationCollectionReusableView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.containerWithTwoButtons.hidden = YES;
}

- (void)prepareHomeMotivationByType:(AdTypes)adTypes {
  [self setupTargetView];
  self.titleLabel.text = adTypes == MotivationFillYourPublicProfile ? @"Заполните свой профиль" : @"Загрузите фотографию";
  self.subTitleLabel.text = adTypes == MotivationFillYourPublicProfile ? @"Людям не интересно просматривать незаполненные анкеты" : @"Твоя анкета станет интересна миллионам людей по всему миру";
  self.iconImageView.image = [UIImage imageNamed:adTypes == MotivationFillYourPublicProfile ? @"motivation_profile_icon" : @"motivation_camera_icon"];
  self.containerWithTwoButtons.hidden = adTypes == MotivationFillYourPublicProfile ? YES : NO;
}

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
    [self.delegate showMyProfile];
  }
}

- (IBAction)selectPhotoDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate selectPhotoFromGallery];
  }
}

- (IBAction)capturePhotoDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate openCamera];
  }
}

@end
