//
//  VerificationTableViewCell.m
//  Yammy
//
//  Created by Alex on 20.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "VerificationTableViewCell.h"

@interface VerificationTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation VerificationTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.height / 2.f;
  self.iconImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareVerificationCellByDictionary:(NSDictionary *)dict {
  self.titleLabel.text = [dict objectForKey:@"title"];
  self.statusLabel.text = @"";
}

@end
