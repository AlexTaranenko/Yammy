//
//  UIViewController+Carousel.m
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "UIViewController+Carousel.h"
#import <objc/runtime.h>
#import "MyPublicProfileViewController.h"
#import "MyPrivateProfileViewController.h"
#import "PublicProfileViewController.h"
#import "PrivateProfileViewController.h"
#import "UIImage+FixOrientation.h"
#import "HomeViewController.h"
#import "HotPageViewController.h"

typedef enum : NSUInteger {
  PhotoCameraRow = 0,
  BoomerangRow,
  PhotoGalleryRow,
} EnumCameraRow;

static void *AssociationEditProfileView = &AssociationEditProfileView;
static void *AssociationFullImageView = &AssociationFullImageView;
static void *AssociationPopoverController = &AssociationPopoverController;

@implementation UIViewController (Carousel)

#pragma mark - Property

- (EditProfileView *)editProfileView {
  return objc_getAssociatedObject(self, AssociationEditProfileView);
}

- (void)setEditProfileView:(EditProfileView *)editProfileView {
  objc_setAssociatedObject(self, &AssociationEditProfileView, editProfileView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FullImageView *)fullImageView {
  return objc_getAssociatedObject(self, AssociationFullImageView);
}

- (void)setFullImageView:(FullImageView *)fullImageView {
  objc_setAssociatedObject(self, &AssociationFullImageView, fullImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WYPopoverController *)popoverController {
  return objc_getAssociatedObject(self, AssociationPopoverController);
}

- (void)setPopoverController:(WYPopoverController *)popoverController {
  objc_setAssociatedObject(self, &AssociationPopoverController, popoverController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Carousel

- (UIView *)prepareCarouselView {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180.0f, 180.0f)];
  view.contentMode = UIViewContentModeCenter;
  view.backgroundColor = [UIColor grayColor];
  view.layer.borderColor = [UIColor whiteColor].CGColor;
  view.layer.borderWidth = 2.f;
  view.layer.cornerRadius = view.frame.size.height / 2.f;
  view.clipsToBounds = YES;
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.tag = 1;
  [view addSubview:imageView];
  
  UIControl *control = [self setupControlByView:view];
  control.hidden = YES;
  [view addSubview:control];
  
  return view;
}

- (UIControl *)setupControlByView:(UIView *)view {
  CGFloat offsetY = view.bounds.size.height - 35.f;
  UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, offsetY, view.bounds.size.width, view.bounds.size.height - offsetY)];
  control.backgroundColor = [UIColor clearColor];
  control.tag = 10;
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:control.bounds];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.backgroundColor = [UIColor clearColor];
  imageView.image = [UIImage imageNamed:@"plus_photo_bg"];
  [control addSubview:imageView];
  
  CGFloat imageWidth = 25.f;
  CGFloat imageHeight = imageWidth;
  
  UIImageView *plusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(control.bounds.size.width / 2 - imageWidth / 2, control.bounds.size.height / 2 - imageHeight / 1.4f, imageWidth, imageHeight)];
  plusImageView.image = [UIImage imageNamed:@"plus_image_icon"];
  [control addSubview:plusImageView];
  
  return control;
}

- (UIView *)prepareCarouserCellByCarousel:(iCarousel *)carousel reusingView:(UIView *)view items:(NSArray *)items andItemAtIndex:(NSInteger)index {
  view = [self prepareCarouselView];
  
  //  if (carousel.currentItemView == nil) {
  //    [self setupViewByView:view backgroundColor:[UIColor clearColor] hideControl:NO];
  //  }
  
  if ([self isKindOfClass:[PublicProfileViewController class]] || [self isKindOfClass:[PrivateProfileViewController class]]) {
    [self setupViewByView:view backgroundColor:[UIColor clearColor] hideControl:YES];
  } else {
    if (carousel.currentItemView == nil) {
      [self setupViewByView:view backgroundColor:[UIColor clearColor] hideControl:NO];
    }
  }
  
  UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
  
  id object = [items objectAtIndex:index];
  if ([object isKindOfClass:[NSNumber class]]) {
    [self prepareImagePhotoByImageView:imageView andImageMapping:nil];
  } else {
    ImageMapping *imageMapping = [items objectAtIndex:index];
    [self prepareImagePhotoByImageView:imageView andImageMapping:imageMapping];
  }
  
  return view;
}

- (void)prepareImagePhotoByImageView:(UIImageView *)imageView andImageMapping:(ImageMapping *)imageMapping {
  if (imageMapping != nil) {
    NSString *urlImage = imageMapping.Url;
    urlImage = [urlImage substringToIndex:[urlImage length] - 1];
    NSNumber *width = nil;
    if ([self isKindOfClass:[PrivateProfileViewController class]]) {
      if ([[(PrivateProfileViewController *)self privateProfileMapping].IsHidden boolValue]) {
        width = @(20);
      } else {
        width = @([UIScreen mainScreen].bounds.size.width / 2);
      }
    } else {
      width = @([UIScreen mainScreen].bounds.size.width / 2);
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@%ld?Token=%@", MAIN_URL, urlImage, (long)[width integerValue], [Helpers getAccessToken]];
    NSURL *url = [NSURL URLWithString:urlString];
    if (url != nil) {
      [self setupImageByImageView:imageView andUrlImage:url];
    } else {
      imageView.image = [UIImage imageNamed:@"placeholder_image"];
    }
  } else {
    imageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)setupImageByImageView:(UIImageView *)imageView andUrlImage:(NSURL *)urlImage {
  [imageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    dispatch_async(dispatch_get_main_queue(), ^{
      imageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
    });
  }];
}

- (void)setupViewByView:(UIView *)view backgroundColor:(UIColor *)color hideControl:(BOOL)hide {
  view.backgroundColor = color;
  UIControl *control = (UIControl *)[view viewWithTag:10];
  [control addTarget:self action:@selector(openEditProfileView:) forControlEvents:UIControlEventTouchUpInside];
  control.hidden = hide;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([self isKindOfClass:[MyPublicProfileViewController class]]) {
      MyPublicProfileViewController *myPublicProfileVC = (MyPublicProfileViewController *)self;
      id object = [myPublicProfileVC.photosArray objectAtIndex:index];
      if ([object isKindOfClass:[ImageMapping class]]) {
        ImageMapping *mapping = (ImageMapping *)object;
        [self presentFullImageByImageMapping:mapping andIsPublicVC:YES];
      }
    } else if ([self isKindOfClass:[MyPrivateProfileViewController class]]) {
      MyPrivateProfileViewController *myPrivateProfileVC = (MyPrivateProfileViewController *)self;
      id object = [myPrivateProfileVC.photosArray objectAtIndex:index];
      if ([object isKindOfClass:[ImageMapping class]]) {
        ImageMapping *mapping = (ImageMapping *)object;
        [self presentFullImageByImageMapping:mapping andIsPublicVC:NO];
      }
    } else if ([self isKindOfClass:[PublicProfileViewController class]] || [self isKindOfClass:[PrivateProfileViewController class]]) {
      id object = nil;
      if ([self isKindOfClass:[PublicProfileViewController class]]) {
        PublicProfileViewController *publicProfileViewController = (PublicProfileViewController *)self;
        object = [publicProfileViewController.photosArray objectAtIndex:index];
        if ([object isKindOfClass:[ImageMapping class]]) {
          ImageMapping *mapping = (ImageMapping *)object;
          [self presentFullImageByImageMapping:mapping];
        }
      } else {
        PrivateProfileViewController *privateProfileViewController = (PrivateProfileViewController *)self;
        object = [privateProfileViewController.photosArray objectAtIndex:index];
        if ([object isKindOfClass:[ImageMapping class]] && [privateProfileViewController.privateProfileMapping.IsHidden boolValue] == NO) {
          ImageMapping *mapping = (ImageMapping *)object;
          [self presentFullImageByImageMapping:mapping];
        }
      }
    }
  });
}

- (void)presentFullImageByImageMapping:(ImageMapping *)mapping andIsPublicVC:(BOOL)isPublic {
  self.fullImageView = [FullImageView prepareFullImageView];
  self.fullImageView.delegate = self;
  self.fullImageView.imageMapping = mapping;
  self.fullImageView.isMyPublicPhoto = isPublic;
  [self.fullImageView preparePhotoImageView];
  [self.fullImageView.layer addAnimation:[Helpers setupAnimation] forKey:kCATransition];
  [self.view addSubview:self.fullImageView];
}

- (void)presentFullImageByImageMapping:(ImageMapping *)mapping {
  self.fullImageView = [FullImageView prepareFullImageView];
  self.fullImageView.delegate = self;
  [self.fullImageView preparePhotoImageViewByImageMapping:mapping];
  [self.fullImageView.layer addAnimation:[Helpers setupAnimation] forKey:kCATransition];
  [self.view addSubview:self.fullImageView];
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
  //items in the center are scaled by this factor
  //  const CGFloat centerScale = 2.5;
  const CGFloat centerScale = 2.0;
  //the larger the xFactor, the smaller the magnified area
  //  const CGFloat xFactor = 0.7f;
  const CGFloat xFactor = 1.6f;
  //should the gap also be scaled? or keep it constant.
  const BOOL scaleGap = YES;
  
  //  const CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:0.8 * 0.6];
  const CGFloat spacing = [self carousel:carousel valueForOption:iCarouselOptionSpacing withDefault:0.8 * 0.6];
  
  const CGFloat gap = scaleGap?0.0:spacing-1.0;
  
  //counting x offset to keep a constant gap
  CGFloat scaleOffset = 0.0;
  float x = fabs(offset);
  for(;x >= 0.0; x-=1.0) {
    scaleOffset+=[self scaleForX:x xFactor:xFactor centerScale:centerScale];
    scaleOffset+= ((x>=1.0)?gap:x*gap);
  }
  
  scaleOffset -= [self scaleForX:offset xFactor:xFactor centerScale:centerScale]/2.0;
  scaleOffset += (x+0.5)*[self scaleForX:(x+(x>-0.5?0.0:1.0)) xFactor:xFactor centerScale:centerScale];
  scaleOffset *= offset<0.0?-1.0:1.0;
  scaleOffset *= scaleGap?spacing:1.0;
  
  CGFloat scale = [self scaleForX:offset xFactor:xFactor centerScale:centerScale];
  transform = CATransform3DTranslate(transform, scaleOffset*carousel.itemWidth, 0.0, 0.0);
  transform = CATransform3DScale(transform, scale, scale, 1.0);
  return transform;
}

-(CGFloat) scaleForX:(CGFloat)x xFactor:(CGFloat)xFactor centerScale:(CGFloat)centerScale {
  return (1+1/(sqrtf(x*x*x*x*xFactor*xFactor*xFactor*xFactor+1))*(centerScale-1.0))/centerScale;
}

#pragma mark - Popover

- (void)presentPopoverBySender:(id)sender isEditPhoto:(BOOL)isEditPhoto {
  if (self.popoverController == nil) {
    UIButton *button = (id)sender;
    MenuPhotoViewController *menuPhotoVC = (MenuPhotoViewController *)[Helpers createCustomVCByStoryboardName:@"MenuPhoto" andStoryboardId:MENU_PHOTO_STORYBOARD_ID];
    menuPhotoVC.isMyPublicEditPhoto = isEditPhoto;
    
    menuPhotoVC.preferredContentSize = CGSizeMake(225, 148);
    
    menuPhotoVC.delegate = self;
    self.popoverController = [[WYPopoverController alloc] initWithContentViewController:menuPhotoVC];
    self.popoverController.passthroughViews = @[button];
    self.popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 34);
    self.popoverController.wantsDefaultContentAppearance = YES;
    self.popoverController.theme.arrowBase = 20;
    self.popoverController.theme.arrowHeight = 7;
    
    [self.popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionDown animated:YES options:WYPopoverAnimationOptionFadeWithScale];
  } else {
    [self dismissPopoverView];
  }
}

- (void)dismissPopoverView {
  [self.popoverController dismissPopoverAnimated:YES completion:^{
    [self popoverControllerDidDismissPopover:self.popoverController];
  }];
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller {
  if (controller == self.popoverController) {
    self.popoverController = nil;
  }
}

- (void)closePopoverByIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == BumerangPublicRow) {
    //      To Do
  } else if (indexPath.row == GalleryPublicRow) {
    [self presentPhotoGallery];
  } else {
    [self presentCameraPhoto];
  }
  
  [self dismissPopoverView];
}

#pragma mark - Handle

- (void)openEditProfileView:(UIControl *)sender {
  dispatch_async(dispatch_get_main_queue(), ^{
    self.editProfileView = [EditProfileView createEditProfileView];
    self.editProfileView.delegate = self;
    [self.editProfileView setupItemsArray];
    [self.editProfileView.layer addAnimation:[Helpers setupAnimation] forKey:kCATransition];
    [self.view addSubview:self.editProfileView];
  });
}

#pragma mark - Delegate

- (void)presentImagePickerByIndexPath:(NSIndexPath *)indexPath {
  [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    self.editProfileView.alpha = 0.0;
  } completion:^(BOOL finished) {
    if (indexPath.row == PhotoCameraRow) {
      [self presentCameraPhoto];
    } else if (indexPath.row == BoomerangRow) {
      //      To Do
    } else {
      [self presentPhotoGallery];
    }
    [self.editProfileView removeFromSuperview];
  }];
}

- (void)dismissFullImageView {
  [Helpers dismissCustomView:self.fullImageView];
}

- (void)deleteImageWithImageMapping:(ImageMapping *)imageMapping {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"Id" : imageMapping.IdImage
                           };
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] deletePhotoWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    [self reloadCarouselAtTheControllerByStatus:status ansErrorMessage:errorMessage];
  }];
}

- (void)setupAvatarImageWithImageMapping:(ImageMapping *)imageMapping {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"Id" : imageMapping.IdImage
                           };
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] setupAvatarPhotoWithParams:params withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    [self reloadCarouselAtTheControllerByStatus:status ansErrorMessage:errorMessage];
  }];
}

- (void)moveImageWithImageMapping:(ImageMapping *)imageMapping {
  NSDictionary *params = @{@"Token" : [Helpers getAccessToken],
                           @"Id" : imageMapping.IdImage
                           };
  NSString *path = [self isKindOfClass:[MyPublicProfileViewController class]] ? MOVE_PHOTO_TO_PRIVATE : MOVE_PHOTO_TO_PUBLIC;
  
  [Helpers showSpinner];
  [[ServerManager sharedManager] movePhotoToProfileWithParams:params andPath:path withCompletion:^(BOOL status, NSString *errorMessage) {
    [Helpers hideSpinner];
    [self reloadCarouselAtTheControllerByStatus:status ansErrorMessage:errorMessage];
  }];
}

- (void)reloadCarouselAtTheControllerByStatus:(BOOL)status ansErrorMessage:(NSString *)errorMessage {
  if ([self isKindOfClass:[MyPublicProfileViewController class]]) {
    MyPublicProfileViewController *myPublicProfileVC = (MyPublicProfileViewController *)self;
    myPublicProfileVC.uploadPhotoImageBlock(status, errorMessage);
  } else {
    MyPrivateProfileViewController *myPrivateProfileVC = (MyPrivateProfileViewController *)self;
    myPrivateProfileVC.uploadPhotoImageBlock(status, errorMessage);
  }
  [self dismissFullImageView];
}

#pragma mark - Private

- (void)presentCameraPhoto {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypeCamera];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нет камеры" title:@"Отсутствует камера"];
  }
}

- (void)presentPhotoGallery {
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
    [self presentPickerViewBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
  } else {
    [UIAlertHelper alert:@"К сожалению, на этом устройстве нету галлереи" title:@"Отсутствует галлерея"];
  }
}

- (void)presentPickerViewBySourceType:(UIImagePickerControllerSourceType)sourceType {
  [Helpers showSpinner];
  UIImagePickerController *picker = [UIImagePickerController new];
  picker.delegate = self;
  picker.allowsEditing = NO;
  picker.sourceType = sourceType;
  if (sourceType == UIImagePickerControllerSourceTypeCamera) {
    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
  }
  [self presentViewController:picker animated:YES completion:^{
    [Helpers hideSpinner];
  }];
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  [Helpers showSpinner];
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  [picker dismissViewControllerAnimated:YES completion:^{
    [Helpers hideSpinner];
    if (image) {
      if ([self isKindOfClass:[HotPageViewController class]]) {
        HotPageViewController *hotPageViewController = (HotPageViewController *)self;
        if (hotPageViewController.verificationPhotoView.isOpenVerify) {
          [hotPageViewController.verificationPhotoView presentMyPhotoByImage:image];
        } else {
          [self presentCropVCByImage:image];
        }
      } else {
        [self presentCropVCByImage:image];
      }
    }
  }];
}

- (void)presentCropVCByImage:(UIImage *)image {
  TOCropViewController *cropVC = [[TOCropViewController alloc] initWithImage:image];
  cropVC.delegate = self;
  [self.navigationController presentViewController:cropVC animated:YES completion:nil];
}

- (void)updatePhotoGalleryByStatus:(BOOL)status withErrorMessage:(NSString *)errorMessage {
  if ([self isKindOfClass:[MyPublicProfileViewController class]]) {
    MyPublicProfileViewController *myPublicProfileViewController = (MyPublicProfileViewController *)self;
    myPublicProfileViewController.uploadPhotoImageBlock(status, errorMessage);
  } else if ([self isKindOfClass:[MyPrivateProfileViewController class]]) {
    MyPrivateProfileViewController *myPrivateProfileViewController = (MyPrivateProfileViewController *)self;
    myPrivateProfileViewController.uploadPhotoImageBlock(status, errorMessage);
  }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
  [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
  [cropViewController dismissViewControllerAnimated:YES completion:^{
    NSData *fileData = UIImageJPEGRepresentation([image fixOrientation], 1.0);
    NSString *path = nil;
    if ([self isKindOfClass:[MyPublicProfileViewController class]] || [self isKindOfClass:[HomeViewController class]] || [self isKindOfClass:[HotPageViewController class]]) {
      path = UPDATE_PROFILE_VIEW;
    } else {
      path = UPDATE_PROFILE_PRIVATE_VIEW;
    }
    
    [Helpers showSpinner];
    [[ServerManager sharedManager] uploadImageToServerByData:fileData withPath:path withCompletion:^(BOOL status, NSString *errorMessage) {
      [Helpers hideSpinner];
      [self updatePhotoGalleryByStatus:status withErrorMessage:errorMessage];
    }];
  }];
}

@end

