//
//  TitlePrivateProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 12.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TitlePrivateProfileTableViewCell.h"

@interface TitlePrivateProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TitlePrivateProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareTitlePrivateProfileTableViewCellByTitle:(NSString *)title andImageIcon:(UIImage *)iconImage {
  self.iconImageView.image = iconImage;
  self.titleLabel.text = title;
}

- (void)changePhotoImageContentMode:(UIViewContentMode)contentMode {
  self.iconImageView.contentMode = contentMode;
}

@end
