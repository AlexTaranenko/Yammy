//
//  ServicesCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 10/25/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kServicesCollectionCellIdentifier = @"servicesCollectionCell";

@interface ServicesCollectionViewCell : UICollectionViewCell

- (void)prepareServicesCollectionCellByServicesMapping:(ServicesMapping *)servicesMapping;

@end

