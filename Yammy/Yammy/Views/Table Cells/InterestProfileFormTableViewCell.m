//
//  InterestProfileFormTableViewCell.m
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "InterestProfileFormTableViewCell.h"

@interface InterestProfileFormTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation InterestProfileFormTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareInterestProfileCellByMapping:(InterestsMapping *)mapping {
  self.titleLabel.text = mapping.Group;
  self.answerLabel.text = @"";
}

- (void)prepareAnswerByArray:(NSArray *)array {
  NSMutableString *mutString = [NSMutableString new];

  for (InterestMapping *mapping in array) {
    [mutString appendString:mapping.Title];
    NSInteger index = [array indexOfObject:mapping];
    if (index + 1 != array.count) {
      [mutString appendString:@", "];
    }
  }
  
  self.answerLabel.text = mutString;
}

@end

