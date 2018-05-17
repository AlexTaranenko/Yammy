//
//  NewRegisterViewController.h
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginModel.h"

@interface NewRegisterViewController : UIViewController

@property (strong, nonatomic) LoginModel *loginModel;
@property (assign, nonatomic) BOOL isFromMyAccount;
@property (assign, nonatomic) BOOL isFromLogin;

@end

