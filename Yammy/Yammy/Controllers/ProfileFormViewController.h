//
//  ProfileFormViewController.h
//  Yammy
//
//  Created by Alex on 10/17/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProfileAboutMeModel.h"

@protocol ProfileFormViewControllerDelegate <NSObject>

- (void)reloadAboutMeSection;

@end

@interface ProfileFormViewController : UIViewController

@property (weak, nonatomic) id<ProfileFormViewControllerDelegate> delegate;

@property (strong, nonatomic) PublicProfileAboutMeModel *publicProfileAboutMeModel;

@property (strong, nonatomic) NSArray *userInterests;

@property (assign, nonatomic, getter=isAboutMe) BOOL isAboutMe;

@end

