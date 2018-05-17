//
//  MotivationCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "MotivationCollectionViewCell.h"

@interface MotivationCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MotivationCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)prepareMotivationCellByModel:(MotivationModel *)motivationModel {
  self.iconImageView.image = [UIImage imageNamed:motivationModel.imageName];
  self.titleLabel.text = motivationModel.titleCell;
}

@end
