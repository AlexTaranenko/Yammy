//
//  HelpTableViewCell.m
//  Yammy
//
//  Created by Alex on 2/22/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HelpTableViewCell.h"

@interface HelpTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *disclosureImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutSubTitleHeight;

@end

@implementation HelpTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareHelpCellByHelpMapping:(HelpMapping *)helpMapping {
  self.titleLabel.text = helpMapping.Title;
}

- (void)prepareHelpCellByArticleModel:(ArticleModel *)articleModel {
  self.titleLabel.text = articleModel.articleMapping.Title;
  self.subTitleLabel.text = articleModel.isShowContent ? articleModel.articleMapping.Content : nil;
  self.layoutSubTitleHeight.constant = articleModel.isShowContent ? [self getLabelHeight:self.subTitleLabel] + 20 : 0;
  self.disclosureImageView.transform = CGAffineTransformMakeRotation(!articleModel.isShowContent ? M_PI_2 : -M_PI_2);
  self.titleLabel.textColor = articleModel.isShowContent ? RGB(249, 0, 64) : [UIColor blackColor];
}

- (CGFloat)getLabelHeight:(UILabel*)label {
  CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
  CGSize size;
  
  NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
  CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:label.font}
                                                context:context].size;
  
  size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
  
  return size.height;
}

@end

