//
//  CirclesCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 9/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesMapping.h"

@interface CirclesCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) PreferencesMapping *preferencesMapping;

- (void)setupRoundCell;

@end

