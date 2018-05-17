//
//  SegmentCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 2/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kSegmentCollectionCellIdentifier = @"segmentCollectionCell";

@interface SegmentCollectionViewCell : UICollectionViewCell

- (void)prepareSegmentByTitle:(NSString *)title andCurrentIndex:(NSInteger)currentIndex andSelectedIndex:(NSInteger)selectedIndex;

@end

