//
//  FullImageCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 3/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kFullImageCollectionCellIdentifier = @"fullImageCollectionCell";

@interface FullImageCollectionViewCell : UICollectionViewCell

- (void)prepareFullImageCollectionCellByImageMapping:(ImageMapping *)imageMapping;

@end
