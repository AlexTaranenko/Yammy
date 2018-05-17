//
//  PrivateProfileViewController.h
//  Yammy
//
//  Created by Alex on 26.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@interface PrivateProfileViewController : UIViewController

@property (strong, nonatomic) ProfileMapping *profileMapping;

@property (strong, nonatomic) PrivateProfileMapping *privateProfileMapping;

@property (strong, nonatomic) NSArray *photosArray;

@property (assign, nonatomic) BOOL isShowPirvateProfile;

@end

