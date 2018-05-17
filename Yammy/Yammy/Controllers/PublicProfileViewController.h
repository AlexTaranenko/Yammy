//
//  PublicProfileViewController.h
//  Yammy
//
//  Created by Alex on 17.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@protocol PublicProfileViewControllerDelegate <NSObject>

@optional

- (void)presentPrivateProfileVC;

@end

@interface PublicProfileViewController : UIViewController

@property (weak, nonatomic) id<PublicProfileViewControllerDelegate> delegate;

@property (strong, nonatomic) ProfileMapping *profileMapping;

@property (strong, nonatomic) NSArray *photosArray;

@end

