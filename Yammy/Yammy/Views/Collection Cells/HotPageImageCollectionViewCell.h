//
//  HotPageImageCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 10/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kHotPageImageCollectionCellIdentifier = @"hotPageImageCollectionCell";

@interface HotPageImageCollectionViewCell : UICollectionViewCell

- (void)preparePhotoImageByImageMapping:(ImageMapping *)imageMapping;

- (void)prepareCornerRadius;

@property (strong, nonatomic) ProfileMapping *profileMapping;

@end

