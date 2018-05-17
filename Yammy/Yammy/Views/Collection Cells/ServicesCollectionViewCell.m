//
//  ServicesCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 10/25/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ServicesCollectionViewCell.h"

@interface ServicesCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation ServicesCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.layer.cornerRadius = 5.f;
  self.clipsToBounds = YES;
}

- (void)prepareServicesCollectionCellByServicesMapping:(ServicesMapping *)servicesMapping {
  self.titleLabel.text = servicesMapping.Title;
  self.subTitleLabel.text = servicesMapping.Description;
}

@end

