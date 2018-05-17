//
//  VerificationPhotoView.h
//  Yammy
//
//  Created by Alex on 5/15/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerificationPhotoViewDelegate <NSObject>

- (void)hideVerificationPhotoView;

- (void)presentGalleryVerificationPhotoView;

- (void)presentCameraVerificationPhotoView;

@end

@interface VerificationPhotoView : UIView

@property (assign, nonatomic) BOOL isOpenVerify;

@property (weak, nonatomic) id<VerificationPhotoViewDelegate> delegate;

+ (VerificationPhotoView *)createVerificationPhotoView;

- (void)presentMyPhotoByImage:(UIImage *)image;

@end
