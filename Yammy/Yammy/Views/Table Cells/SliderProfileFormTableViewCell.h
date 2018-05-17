//
//  SliderProfileFormTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

static NSString *const kSliderProfileFormCellIdentifier = @"sliderProfileFormCell";

@interface SliderProfileFormTableViewCell : UITableViewCell

@property (assign, nonatomic, getter=isGrowth) BOOL isGrowth;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

- (void)prepareTitleLabelByTitleText:(NSString *)titleText;

- (void)prepareWeightSizeLabelBiSize:(NSInteger)size;

- (void)setupSliderCurrantValue:(CGFloat)currentValue;

- (void)prepareGrowthSizeLabelBiSize:(NSInteger)size;

@end

