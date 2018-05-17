//
//  CoincidenceSearchPrivateTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/4/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "CoincidenceSearchPrivateTableViewCell.h"

@interface CoincidenceSearchPrivateTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *coincidenceButtonsArray;

@end

@implementation CoincidenceSearchPrivateTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.containerView.layer.borderWidth = 1.f;
  self.containerView.layer.borderColor = RGB(235, 235, 235).CGColor;
  self.containerView.layer.cornerRadius = 5.f;
  self.containerView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareShowingButtonsBySearchPrivateModel:(SearchPrivateModel *)searchPrivateModel {
  [self prepareButtons];
}

- (void)prepareButtons {
  int index = 0;
  for (UIButton *button in self.coincidenceButtonsArray) {
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.tag = 10 + index;
    [self customizeButton:button];
    index += 1;
  }
}

- (void)customizeButton:(UIButton *)button {
  if (button.tag == [self.searchPrivateModel.coincidenceUsers integerValue]) {
    button.backgroundColor = RGB(214, 0, 65);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  } else {
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
  }
}

- (IBAction)coincidenceDidTap:(UIButton *)sender {
  UIButton *button = (UIButton *)sender;
  self.searchPrivateModel.coincidenceUsers = @(button.tag);
  [self prepareShowingButtonsBySearchPrivateModel:self.searchPrivateModel];
}

@end
