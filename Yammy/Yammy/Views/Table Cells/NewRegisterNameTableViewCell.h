//
//  NewRegisterNameTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

static NSString *const kNewRegisterNameIdentifier = @"newRegisterName";

@interface NewRegisterNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) RegisterModel *registerModel;

@end
