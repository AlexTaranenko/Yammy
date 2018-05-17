//
//  CarouselViewCell.h
//  Yammy
//
//  Created by Alex on 9/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarouselViewCell : UIView

+ (CarouselViewCell *)prepareCarouselViewCell;

- (void)prepareBorderPhotoImageView;

- (void)prepareCornerRadiusForPhotoImageView;

@end
