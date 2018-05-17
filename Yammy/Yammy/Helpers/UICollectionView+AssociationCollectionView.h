//
//  UICollectionView+AssociationCollectionView.h
//  Yammy
//
//  Created by Alex on 24.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (AssociationCollectionView)<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *preferencesArray;

@property (strong, nonatomic) PrivateProfileMapping *privateProfileMapping;

- (void)prepareAssociationCollectionView;

@end
