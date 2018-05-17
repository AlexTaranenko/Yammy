//
//  CodeRegisterViewController.h
//  Yammy
//
//  Created by Alex on 8/2/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"
#import "RegisterMapping.h"
#import "LoginModel.h"

@interface CodeRegisterViewController : UIViewController

@property (strong, nonatomic) RegisterModel *registerModel;
@property (strong, nonatomic) RegisterMapping *registerMapping;
@property (strong, nonatomic) LoginModel *loginModel;

@end

