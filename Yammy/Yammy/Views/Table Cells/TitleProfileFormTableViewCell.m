//
//  TitleProfileFormTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TitleProfileFormTableViewCell.h"

@interface TitleProfileFormTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TitleProfileFormTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText {
  self.titleLabel.text = titleText;
}

@end

