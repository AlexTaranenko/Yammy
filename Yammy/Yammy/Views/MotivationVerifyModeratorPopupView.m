//
//  MotivationVerifyModeratorPopupView.m
//  Yammy
//
//  Created by Alex on 5/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationVerifyModeratorPopupView.h"

@interface MotivationVerifyModeratorPopupView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet CustomButton *customButtton;

@property (assign, nonatomic) AdTypes adTypes;

@end

@implementation MotivationVerifyModeratorPopupView

+ (MotivationVerifyModeratorPopupView *)createMotivationVerifyModeratorPopupViewByAdType:(AdTypes)adTypes {
  MotivationVerifyModeratorPopupView *motivationVerifyModeratorPopupView = (MotivationVerifyModeratorPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"MotivationVerifyModeratorPopupView" owner:self options:nil] firstObject];
  motivationVerifyModeratorPopupView.frame = [UIScreen mainScreen].bounds;
  motivationVerifyModeratorPopupView.adTypes = adTypes;
  [motivationVerifyModeratorPopupView prepareMotivationVerifyModeratorInterfaceByAdTypes:adTypes];
  return motivationVerifyModeratorPopupView;
}

- (void)prepareMotivationVerifyModeratorInterfaceByAdTypes:(AdTypes)adTypes {
  if (adTypes == MotivationVerifyYourAccount) {
    self.titleLabel.text = @"Пройдите верификацию";
    self.subTitleLabel.text = @"Мы ограждаем Вас от мошенников и спама! Для этого пройдите верификацию";
    [self.customButtton setTitle:@"Пройти верификацию" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Позже" forState:UIControlStateNormal];
  } else {
    self.titleLabel.text = @"Стань онлайн модератором";
    self.subTitleLabel.text = @"Станьте модератором Yammy и получайте вознаграждения за проверку пользователей!";
    [self.customButtton setTitle:@"Стать модератором" forState:UIControlStateNormal];
    [self.cancelButton setTitle:@"Не интерестно" forState:UIControlStateNormal];
  }
}

- (IBAction)selectCustomButtonDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate selectCustomButtonByAdTypes:self.adTypes];
  }
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate closeMotivationVerifyModeratorPopup];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
