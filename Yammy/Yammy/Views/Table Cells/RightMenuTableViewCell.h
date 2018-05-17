//
//  RightMenuTableViewCell.h
//  Yammy
//
//  Created by Alex on 2/16/18.
//  Copyright © 2018 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kRightMenuCellIdentifier = @"rightMenuCell";

@interface RightMenuTableViewCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *dictionary;

@end

