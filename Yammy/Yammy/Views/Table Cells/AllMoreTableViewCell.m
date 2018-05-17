//
//  AllMoreTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllMoreTableViewCell.h"

@interface AllMoreTableViewCell()

@property (weak, nonatomic) IBOutlet CircularImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet CustomLabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation AllMoreTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [self hiddenLabel:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)preparePhotoImageBorder {
  self.photoImageView.borderWidth = @(1.f);
  self.photoImageView.borderColor = RGB(215, 215, 215);
}

- (void)hiddenLabel:(BOOL)hidden {
  self.numberLabel.hidden = hidden;
}

- (void)setDictionary:(NSDictionary *)dictionary {
  NSString *imageName = [dictionary objectForKey:@"image"];
  NSString *name = [dictionary objectForKey:@"name"];
  NSString *message = [dictionary objectForKey:@"message"];
  
  self.nameLabel.text = name;
  self.messageLabel.text = message;
  self.iconImageView.image = [UIImage imageNamed:imageName];
}

@end

