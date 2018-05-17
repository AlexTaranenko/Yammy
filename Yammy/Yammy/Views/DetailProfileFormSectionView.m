//
//  DetailProfileFormSectionView.m
//  Yammy
//
//  Created by Alex on 3/29/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "DetailProfileFormSectionView.h"

@interface DetailProfileFormSectionView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DetailProfileFormSectionView

+ (DetailProfileFormSectionView *)createDetailProfileFormSectionView:(NSString *)title {
  DetailProfileFormSectionView *detailProfileFormSectionView = (DetailProfileFormSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"DetailProfileFormSectionView" owner:self options:nil] firstObject];
  detailProfileFormSectionView.titleLabel.text = title;
  return detailProfileFormSectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
