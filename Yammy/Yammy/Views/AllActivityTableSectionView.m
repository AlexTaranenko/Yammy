//
//  AllActivityTableSectionView.m
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "AllActivityTableSectionView.h"

@interface AllActivityTableSectionView()

@property (weak, nonatomic) IBOutlet CustomLabel *titleLabel;

@end

@implementation AllActivityTableSectionView

+ (AllActivityTableSectionView *)setupAllActivityTableSectionView {
  return (AllActivityTableSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"AllActivityTableSectionView" owner:self options:nil] firstObject];
}

- (void)prepareTitleLabelByText:(NSString *)text {
  self.titleLabel.text = text;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

