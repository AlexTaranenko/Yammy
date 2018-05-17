//
//  ReportTableViewCell.m
//  Yammy
//
//  Created by Alex on 1/18/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "ReportTableViewCell.h"

@interface ReportTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;

@end

@implementation ReportTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareReportCellByModel:(ReportModel *)model andSelect:(BOOL)select {
  self.titleLabel.text = model.titleReport;
  if (select) {
    self.checkBoxImageView.image = [UIImage imageNamed:@"selected_person_register_icon"];
  } else {
    self.checkBoxImageView.image = [UIImage imageNamed:@"select_person_register_icon"];
  }
}

@end

