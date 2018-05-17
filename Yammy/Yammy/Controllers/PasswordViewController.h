//
//  PasswordViewController.h
//  Yammy
//
//  Created by Alex on 12/26/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"
#import "RegisterModel.h"

@interface PasswordViewController : UIViewController

@property (strong, nonatomic) RegisterModel *registerModel;

@property (strong, nonatomic) LoginModel *loginModel;

@end

