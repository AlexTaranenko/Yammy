//
//  NewRegisterCodeTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/7/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

static NSString *const kNewRegisterCodeIdentifier = @"newRegisterCode";

@interface NewRegisterCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;
@property (weak, nonatomic) IBOutlet UITextField *fourTextField;

@property (strong, nonatomic) RegisterModel *registerModel;

@end

