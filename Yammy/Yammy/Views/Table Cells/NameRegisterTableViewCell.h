//
//  NameRegisterTableViewCell.h
//  Yammy
//
//  Created by Alex on 31.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@interface NameRegisterTableViewCell : UITableViewCell

@property (strong, nonatomic) RegisterModel *registerModel;

- (void)prepareNameRegisterByModel:(RegisterModel *)registerModel;

@end

