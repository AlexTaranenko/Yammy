//
//  MyPrivateProfileViewController.h
//  Yammy
//
//  Created by Alex on 18.09.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UploadPhotoImageBlock)(BOOL status, NSString *errorMessage);

@interface MyPrivateProfileViewController : UIViewController

@property (copy, nonatomic) UploadPhotoImageBlock uploadPhotoImageBlock;

@property (strong, nonatomic) NSArray *photosArray;

@end

