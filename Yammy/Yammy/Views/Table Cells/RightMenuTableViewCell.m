//
//  RightMenuTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "RightMenuTableViewCell.h"

@interface RightMenuTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation RightMenuTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setDictionary:(NSDictionary *)dictionary {
  self.nameLabel.text = [dictionary objectForKey:@"title"];
  self.iconImageView.image = [UIImage imageNamed:[dictionary objectForKey:@"image"]];
}

@end

