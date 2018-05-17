//
//  ShowingSearchTableViewCell.m
//  Yammy
//
//  Created by Alex on 01.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ShowingSearchTableViewCell.h"

@interface ShowingSearchTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *containerButtonsView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsArray;

@end

@implementation ShowingSearchTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.containerButtonsView.layer.borderWidth = 1.f;
  self.containerButtonsView.layer.borderColor = RGB(235, 235, 235).CGColor;
  self.containerButtonsView.layer.cornerRadius = 5.f;
  self.containerButtonsView.clipsToBounds = YES;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public

- (void)prepareShowingButtonsBySearchModel:(SearchModel *)searchModel {
  [self prepareButtons];
}

#pragma mark - Private

- (void)prepareButtons {
  int index = 0;
  for (UIButton *button in self.buttonsArray) {
    button.layer.cornerRadius = 5.f;
    button.clipsToBounds = YES;
    button.tag = index;
    [self customizeButton:button];
    index += 1;
  }
}

- (void)customizeButton:(UIButton *)button {
  if (button.tag == [self.searchModel.showingUsers integerValue]) {
    button.backgroundColor = RGB(214, 0, 65);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  } else {
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
  }
}

- (IBAction)selectShowingDidTap:(UIButton *)sender {
  UIButton *button = (UIButton *)sender;
  self.searchModel.showingUsers = @(button.tag);
  [self prepareShowingButtonsBySearchModel:self.searchModel];
}

@end

