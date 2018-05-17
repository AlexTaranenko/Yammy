//
//  MotivationCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 5/3/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kMotivationCollectionCellIdentifier = @"motivationCollectionCell";

@interface MotivationCollectionViewCell : UICollectionViewCell

- (void)prepareMotivationCellByModel:(MotivationModel *)motivationModel;

@end
