//
//  RecoveryPasswordViewController.h
//  Yammy
//
//  Created by Alex on 12/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "RegisterModel.h"

@interface RecoveryPasswordViewController : UIViewController

@property (strong, nonatomic) LoginModel *loginModel;

@property (strong, nonatomic) RegisterModel *registerModel;

@end

