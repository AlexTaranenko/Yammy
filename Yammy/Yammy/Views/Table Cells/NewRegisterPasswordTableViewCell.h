//
//  NewRegisterPasswordTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

static NSString *const kNewRegisterPasswordIdentifier = @"newRegisterPassword";

@interface NewRegisterPasswordTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (strong, nonatomic) RegisterModel *registerModel;

@end

