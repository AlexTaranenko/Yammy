//
//  AllShowProfileTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/9/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllShowProfileCellIdentifier = @"allShowProfileCell";

@interface AllShowProfileTableViewCell : UITableViewCell

- (void)prepareSexImageBorderByColor:(UIColor *)color;

- (void)prepareAllShowProfileByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

