//
//  MyPublicProfileViewController.h
//  Yammy
//
//  Created by Alex on 27.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UploadPhotoImageBlock)(BOOL status, NSString *errorMessage);

@interface MyPublicProfileViewController : UIViewController

@property (copy, nonatomic) UploadPhotoImageBlock uploadPhotoImageBlock;

@property (strong, nonatomic) NSArray *photosArray;

- (void)presentMyGifts;

@end

