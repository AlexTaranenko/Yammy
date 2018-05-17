//
//  VerificationCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 3/19/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kVerificationCollectionCellIdentifier = @"verificationCollectionCell";

@interface VerificationCollectionViewCell : UICollectionViewCell

- (void)prepareIconByName:(NSString *)iconName;

@end
