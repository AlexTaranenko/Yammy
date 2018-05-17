//
//  AddImageProfileTableViewCell.m
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AddImageProfileTableViewCell.h"

@interface AddImageProfileTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AddImageProfileTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)setDictionary:(NSDictionary *)dictionary {
  NSString *imageName = [dictionary objectForKey:@"image"];
  self.photoImageView.image = [UIImage imageNamed:imageName];
  self.titleLabel.text = [dictionary objectForKey:@"title"];
}

@end
