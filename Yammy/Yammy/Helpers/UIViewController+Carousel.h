//
//  UIViewController+Carousel.h
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "EditProfileView.h"
#import "FullImageView.h"
#import <TOCropViewController/TOCropViewController.h>
#import <WYPopoverController/WYPopoverController.h>
#import "MenuPhotoViewController.h"

@interface UIViewController (Carousel)<iCarouselDelegate, EditProfileViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FullImageViewDelegate, TOCropViewControllerDelegate, MenuPhotoViewControllerDelegate>

@property (nonatomic) EditProfileView *editProfileView;

@property (nonatomic) FullImageView *fullImageView;

@property (nonatomic) WYPopoverController *popoverController;

- (UIView *)prepareCarouselView;

- (UIView *)prepareCarouserCellByCarousel:(iCarousel *)carousel reusingView:(UIView *)view items:(NSArray *)items andItemAtIndex:(NSInteger)index;

- (void)setupViewByView:(UIView *)view backgroundColor:(UIColor *)color hideControl:(BOOL)hide;

- (void)presentPopoverBySender:(id)sender isEditPhoto:(BOOL)isEditPhoto;

- (void)presentCameraPhoto;

- (void)presentPhotoGallery;

@end

