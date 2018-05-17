//
//  ProfileViewController.h
//  Yammy
//
//  Created by Alex on 13.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileMapping.h"

@interface ProfileViewController : UIViewController

@property (assign, nonatomic) BOOL isShowProfile;
@property (strong, nonatomic) ProfileMapping *profileMapping;

@end

