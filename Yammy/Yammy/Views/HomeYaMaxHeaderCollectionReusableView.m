//
//  HomeYaMaxHeaderCollectionReusableView.m
//  Yammy
//
//  Created by Alex on 5/6/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "HomeYaMaxHeaderCollectionReusableView.h"
#import "CornerView.h"

@interface HomeYaMaxHeaderCollectionReusableView()

@property (weak, nonatomic) IBOutlet CornerView *cornerView;

@end

@implementation HomeYaMaxHeaderCollectionReusableView

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBilling)];
  [self.cornerView addGestureRecognizer:gesture];
  self.cornerView.userInteractionEnabled = YES;
}

- (void)openBilling {
  if (self.delegate != nil) {
    [self.delegate openServicesScreen];
  }
}

@end
