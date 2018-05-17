//
//  AllPhotoTableViewCell.h
//  Yammy
//
//  Created by Alex on 10/6/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityLineMapping.h"

static NSString *const kAllPhotoCellIdentifier = @"allPhotoCell";

@interface AllPhotoTableViewCell : UITableViewCell

- (void)prepareAllPhotoCellByActivityLineMapping:(ActivityLineMapping *)activityLineMapping;

@end

