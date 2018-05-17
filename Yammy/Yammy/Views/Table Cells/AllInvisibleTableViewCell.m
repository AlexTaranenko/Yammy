//
//  AllInvisibleTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllInvisibleTableViewCell.h"

@interface AllInvisibleTableViewCell()

@property (weak, nonatomic) IBOutlet CustomImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AllInvisibleTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareAllInvisibleCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping {
  self.nameLabel.text = activityLineMapping.Title;
  self.messageLabel.text = activityLineMapping.SubTitle;
}

- (IBAction)openInvisibleDidTap:(CustomButton *)sender {
  if (self.delegate != nil) {
    [self.delegate presentInvisiblePopup];
  }
}

@end

