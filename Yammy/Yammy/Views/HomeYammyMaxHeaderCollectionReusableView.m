//
//  HomeYammyMaxHeaderCollectionReusableView.m
//  Yammy
//
//  Created by Alex on 21.08.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HomeYammyMaxHeaderCollectionReusableView.h"

@interface HomeYammyMaxHeaderCollectionReusableView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *yaMaxLabel;
@property (weak, nonatomic) IBOutlet UIControl *yaMaxControl;

@end

@implementation HomeYammyMaxHeaderCollectionReusableView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  self.titleLabel.text = @"Сними все лимиты, используй\nвозможности YAMMY по максимуму";
  self.yaMaxLabel.text = @"Получить Ya-MAX бесплатно\nпрямо сейчас.";
  
  self.yaMaxControl.layer.cornerRadius = 5.f;
  self.yaMaxControl.clipsToBounds = YES;
}

@end
