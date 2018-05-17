//
//  InterestMeRegisterTableViewCell.h
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@interface InterestMeRegisterTableViewCell : UITableViewCell

@property (strong, nonatomic) RegisterModel *registerModel;

@property (strong, nonatomic) NSString *titleText;

- (void)prepareShowControl;

@end

