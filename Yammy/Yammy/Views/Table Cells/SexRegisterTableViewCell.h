//
//  SexRegisterTableViewCell.h
//  Yammy
//
//  Created by Alex on 31.07.17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@interface SexRegisterTableViewCell : UITableViewCell

@property (strong, nonatomic) RegisterModel *registerModel;

- (void)prepareButtonsByArray:(NSArray *)array;

- (void)prepareSexRegisterByModel:(RegisterModel *)registerModel;

@end

