//
//  AddedCirclesCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 9/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesMapping.h"

@interface AddedCirclesCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) PreferencesMapping *preferencesMapping;

- (void)setupRound;

@end

