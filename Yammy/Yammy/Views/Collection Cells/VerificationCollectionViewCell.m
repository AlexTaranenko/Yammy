//
//  VerificationCollectionViewCell.m
//  Yammy
//
//  Created by Alex on 3/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import "VerificationCollectionViewCell.h"

@interface VerificationCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation VerificationCollectionViewCell

- (void)prepareIconByName:(NSString *)iconName {
  self.iconImageView.image = [UIImage imageNamed:iconName];
}

@end
