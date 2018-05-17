//
//  YearCalendarCollectionViewCell.h
//  Yammy
//
//  Created by Alex on 8/3/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearCalendarCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSNumber *yearNumber;

- (void)prepareBackgroundColor:(BOOL)isPrepare;

@end
