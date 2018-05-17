//
//  UIViewController+ActivityLine.h
//  Yammy
//
//  Created by Alex on 12/5/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import "NSDate+Utilities.h"

@interface UIViewController (ActivityLine)

@property (strong, nonatomic) UIRefreshControl *topRefreshControl;

- (void)setupRefreshControlsByTableView:(UITableView *)tableView;

@end

