//
//  PrivateAssociationsCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 16.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreferencesMapping.h"

static NSString *const kPrivateAssociationsCollectionCellIdentifier = @"privateAssociationsCollectionCell";

@interface PrivateAssociationsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) PreferencesMapping *preferencesMapping;

- (void)preparePhotoImageViewBorder;

- (void)preparePhotoImageViewRadius;

- (void)prepareCloseImageView;

@end
