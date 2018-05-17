//
//  FullImageView.m
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "FullImageView.h"
#import <WYPopoverController/WYPopoverController.h>
#import "MenuPhotoViewController.h"

@interface FullImageView()<MenuPhotoViewControllerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *popoverButton;

@property (strong, nonatomic) WYPopoverController *popoverController;

@end

@implementation FullImageView

+ (FullImageView *)prepareFullImageView {
  FullImageView *fullImageView = [[[NSBundle mainBundle] loadNibNamed:@"FullImageView" owner:self options:nil] firstObject];
  fullImageView.frame = [UIScreen mainScreen].bounds;
  fullImageView.scrollView.minimumZoomScale = 1.0;
  fullImageView.scrollView.maximumZoomScale = 3.0;
  fullImageView.scrollView.zoomScale = 1.0;
  CGPoint centerPoint = CGPointMake(CGRectGetMidX(fullImageView.scrollView.bounds), CGRectGetMidY(fullImageView.scrollView.bounds));
  [fullImageView view:fullImageView.photoImageView setCenter:centerPoint];
  
  fullImageView.layoutBottomHeight.constant = IS_IPHONE_X ? 139 : 113;
  
  return fullImageView;
}

- (void)preparePhotoImageView {
  self.popoverButton.hidden = NO;
  
  if (self.imageMapping != nil) {
    [self prepareImageBuImageUrl:self.imageMapping.Url];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)preparePhotoImageViewByMessageMapping:(MessageMapping *)messageMapping {
  self.popoverButton.hidden = YES;
  self.layoutBottomHeight.constant = IS_IPHONE_X ? 56 : 64;
  if (messageMapping.Image != nil) {
    [self prepareImageBuImageUrl:messageMapping.Image.Url];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (void)preparePhotoImageViewByImageMapping:(ImageMapping *)imageMapping {
  self.popoverButton.hidden = YES;
  [self prepareImageBuImageUrl:imageMapping.Url];
}

- (void)prepareImageBuImageUrl:(NSString *)imageUrl {
  NSString *urlString = [NSString stringWithFormat:@"%@%@?Token=%@", MAIN_URL, imageUrl,  [Helpers getAccessToken]];
  NSURL *urlImage = [NSURL URLWithString:urlString];
  if (urlImage) {
    [Helpers showSpinner];
    [self.photoImageView sd_setImageWithURL:urlImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [Helpers hideSpinner];
        self.photoImageView.image = image ?: [UIImage imageNamed:@"placeholder_image"];
      });
    }];
  } else {
    self.photoImageView.image = [UIImage imageNamed:@"placeholder_image"];
  }
}

- (IBAction)showPopoverDidTap:(id)sender {
  [self showPopover:sender];
}

- (void)showPopover:(id)sender {
  if (self.popoverController == nil) {
    UIView *button = (UIView *)sender;
    MenuPhotoViewController *menuPhotoVC = (MenuPhotoViewController *)[Helpers createCustomVCByStoryboardName:@"MenuPhoto" andStoryboardId:MENU_PHOTO_STORYBOARD_ID];
    menuPhotoVC.isMyPublicPhoto = self.isMyPublicPhoto;
    if (self.isMyPublicPhoto) {
      menuPhotoVC.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 160);
    } else {
      menuPhotoVC.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 60, 120);
    }
    
    menuPhotoVC.delegate = self;
    self.popoverController = [[WYPopoverController alloc] initWithContentViewController:menuPhotoVC];
    self.popoverController.passthroughViews = @[button];
    self.popoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 34);
    self.popoverController.wantsDefaultContentAppearance = YES;
    
    [self.popoverController presentPopoverFromRect:button.bounds inView:button permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES options:WYPopoverAnimationOptionFadeWithScale];
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
  if (self.delegate != nil) {
    switch (self.isMyPublicPhoto == NO ? indexPath.row : indexPath.row + 1) {
      case AvatarPhotoRow:
        [self.delegate setupAvatarImageWithImageMapping:self.imageMapping];
        break;
        
      case MoveToPrivateProfileRow:
        [self.delegate moveImageWithImageMapping:self.imageMapping];
        break;
        
      case DeletePhotoRow:
        [self.delegate deleteImageWithImageMapping:self.imageMapping];
        break;
        
      default:
        break;
    }
    
    [self.delegate dismissFullImageView];
  }
  
  [self dismissPopoverView];
}

- (IBAction)cancelDidTap:(UIButton *)sender {
  if (self.delegate != nil) {
    [self.delegate dismissFullImageView];
  }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
  UIView *zoomView = [scrollView.delegate viewForZoomingInScrollView:scrollView];
  CGRect zvf = zoomView.frame;
  if (zvf.size.width < scrollView.bounds.size.width) {
    zvf.origin.x = (scrollView.bounds.size.width - zvf.size.width) / 2.0;
  } else {
    zvf.origin.x = 0.0;
  }
  
  if (zvf.size.height < scrollView.bounds.size.height) {
    zvf.origin.y = (scrollView.bounds.size.height - zvf.size.height) / 2.0;
  } else {
    zvf.origin.y = 0.0;
  }
  
  zoomView.frame = zvf;
}

- (void)view:(UIView *)view setCenter:(CGPoint)centerPoint {
  CGRect vf = view.frame;
  CGPoint co = self.scrollView.contentOffset;
  
  CGFloat x = centerPoint.x - vf.size.width / 2.0;
  CGFloat y = centerPoint.y - vf.size.height / 2.0;
  
  if (x < 0) {
    co.x = -x;
    vf.origin.x = 0.0;
  } else {
    vf.origin.x = x;
  }
  
  if (y < 0) {
    co.y = -y;
    vf.origin.y = 0.0;
  } else {
    vf.origin.y = y;
  }
  
  view.frame = vf;
  self.scrollView.contentOffset = co;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

