//
//  MyTitlePrivateProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MyTitlePrivateProfileTableViewCell.h"

@interface MyTitlePrivateProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *showHideLabel;

@end

@implementation MyTitlePrivateProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareMyTitlePrivateProfileCellWithModel:(MyTitlePrivateProfileModel *)myTitlePrivateProfileModel {
  self.titlelabel.text = myTitlePrivateProfileModel.title;
  self.showHideLabel.text = myTitlePrivateProfileModel.titleButton;
}

@end

