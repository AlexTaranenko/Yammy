//
//  CalendarRegisterViewController.h
//  Yammy
//
//  Created by Alex on 8/1/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterModel.h"

@protocol CalendarRegisterViewControllerDelegate <NSObject>

- (void)prepareBirthdayTableCell;

@end

@interface CalendarRegisterViewController : UIViewController

@property (assign, nonatomic) id<CalendarRegisterViewControllerDelegate> delegate;

@property (strong, nonatomic) RegisterModel *registerModel;

@end
