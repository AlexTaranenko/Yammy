//
//  TutorialCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 2/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kTutorialCollectionCellIdentifier = @"tutorialCollectionCell";

@interface TutorialCollectionViewCell : UICollectionViewCell

- (void)prepareImageByName:(NSString *)imageName;

@end
