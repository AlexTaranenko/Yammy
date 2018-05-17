//
//  FullImageViewController.h
//  Yammy
//
//  Created by Alex on 3/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullImageViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *photosArray;

@property (assign, nonatomic) BOOL isMyProfile;
@property (assign, nonatomic) BOOL isMyPublicProfile;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
