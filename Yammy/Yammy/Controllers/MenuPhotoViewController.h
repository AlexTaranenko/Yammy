//
//  MenuPhotoViewController.h
//  Yammy
//
//  Created by Alex on 27.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuPhotoViewControllerDelegate <NSObject>

@optional
- (void)closePopoverByIndexPath:(NSIndexPath *)indexPath;

@end

@interface MenuPhotoViewController : UIViewController

@property (assign, nonatomic) BOOL isMyPublicPhoto;

@property (assign, nonatomic) BOOL isMyPublicEditPhoto;

@property (weak, nonatomic) id<MenuPhotoViewControllerDelegate> delegate;

@end

